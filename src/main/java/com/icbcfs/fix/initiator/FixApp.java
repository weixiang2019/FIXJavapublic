/**
 * The main application object for sending FIX messages and receiving FIX
 * messages.
 */
package com.icbcfs.fix.initiator;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.Objects;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import quickfix.DoNotSend;
import quickfix.FieldConvertError;
import quickfix.FieldNotFound;
import quickfix.IncorrectDataFormat;
import quickfix.IncorrectTagValue;
import quickfix.Message;
import quickfix.RejectLogon;
import quickfix.Session;
import quickfix.SessionID;
import quickfix.SessionNotFound;
import quickfix.UnsupportedMessageType;
import quickfix.field.MsgType;
import quickfix.fix44.ExecutionReport;
import quickfix.SessionSettings;
import quickfix.StringField;
import quickfix.ConfigError;

public class FixApp implements quickfix.Application{
	
	// log config file: src/main/resources/config/log4j2.yaml
	public static final int DEFAULT_POLLING_INTERVAL = 100;
	public static final int DEFAULT_MAX_DB_CONNECTION_RETRIES = 3;
	private static final Logger LOGGER = LoggerFactory.getLogger(FixApp.class);
	private SQLConnector[] sources;
	private boolean connect;
	private SessionSettings settings;
	private SessionID sessionId;
	private boolean pollForTrades;
	private int pollingInterval;
	
	/**
	 * Because the app creates a SQLConnector for each trade source, but any of
	 * the SQLConnector instances can insert Gems acknowledgments in the DB,
	 * the app designates a connector for inserting.
	 */
	private int insertConnectorIndex;

	private boolean running;

	private FixApp(
			SQLConnector[] sources,
			int insertConnectorIndex,
			int pollingInterval,
			int dbConnectionMaxRetries,
			SessionSettings settings,
			boolean connect
	) {
		this.sources = sources;
		this.pollingInterval = pollingInterval;
		this.settings = settings;
		this.connect = connect;
		this.insertConnectorIndex = insertConnectorIndex;
	}
	
	/**
	 * Constructor method for creating the FixApp object.
	 * @param settings QuickFIX/J session settings that has the various settings
	 * this app needs.
	 * @param sqlConfigFilePaths a list of SQL config files that the app will
	 * use for creating trade sources for polling.
	 * @param connect whether this app will connect to the database or not.
	 * @return a FixApp created according to the passed in settings if there's
	 * no issues. If there is, method will return null.
	 */
	public static FixApp getApp(SessionSettings settings, String[] sqlConfigFilePaths, boolean connect) {
		int pollingInterval = getIntFromSettings("PollingInterval", settings);
		if (pollingInterval == -1) {
			pollingInterval = DEFAULT_POLLING_INTERVAL;
			LOGGER.info("Using default value for PollingInterval: {}.",
					DEFAULT_POLLING_INTERVAL);
		}
		int dbConnectionMaxRetries =
				getIntFromSettings("DBConnectionMaxRetries", settings);
		if (dbConnectionMaxRetries == -1) {
			dbConnectionMaxRetries = DEFAULT_MAX_DB_CONNECTION_RETRIES;
			LOGGER.info("Using default value for DBConnectionMaxRetries: {}.",
					DEFAULT_MAX_DB_CONNECTION_RETRIES);
		}
		SQLConnector[] sources = null;
		int insertConnectorIndex = -1;
		if (connect) {
			if (sqlConfigFilePaths == null) {
				LOGGER.error("Program is set to connect to database but cannot "
						+ "find any connection configuration files!");
				return null;
			}
			sources = new SQLConnector[sqlConfigFilePaths.length];
			LOGGER.info("Creating SQLConnector instances...");
			for (int i = 0; i < sqlConfigFilePaths.length; i++) {
				SQLConnector connector = SQLConnector.getConnector(sqlConfigFilePaths[i], dbConnectionMaxRetries);
				if (connector != null) {
					sources[i] = connector;
					insertConnectorIndex = i;
				} else {
					LOGGER.warn("A SQL connection for the trade source config {} failed to open. "
							+ "Program will continue running, but won't poll the mentioned source for trades. "
							+ "See logging above for additional info.", sqlConfigFilePaths[i]);
				}
			}
			// if program exited the for loop without an insertConnector,
			// then no SQLConnector was successfully created
			// program returns null to indicate that it's supposed to connect to the database,
			// but could not properly initialize a connector
			if (insertConnectorIndex == -1) {
				return null;
			}
		}
		return new FixApp(sources, insertConnectorIndex, pollingInterval, dbConnectionMaxRetries, settings, connect);
	}
	
	/**
	 * Helper method for reading the given key as an int from the given
	 * settings.
	 * @param key the key of the parameter the method will grab from the
	 * given settings.
	 * @param settings the map from which the method will look for the given
	 * key.
	 * @return the value of the given key as an int. If the key cannot be found
	 * or if the value cannot be converted into an int, method will return -1.
	 */
	private static int getIntFromSettings(String key, SessionSettings settings) {
		int output = -1;
		try {
			output = settings.getInt(key);
		} catch(ConfigError configError) {
			LOGGER.debug("{} not set under DEFAULT settings.", key);
		} catch(FieldConvertError convertError) {
			LOGGER.debug("{} set but cannot be read as an int.", key);
		}
		return output;
	}

	/**
	 * QuickFIX/J callback method. This will be trigger when the QuickFIX/J
	 * engine creates a session. This will check to see if this session is set
	 * to poll the database or not and override the starting sequence numbers
	 * if specified.
	 * 
	 * If starting sequence number is set to be overridden, the app will reset
	 * the override setting so that it won't override it the next time it starts
	 * up.
	 */
	@Override
	public void onCreate(SessionID sessionId) {
		LOGGER.info("ID: {}: Session created.", sessionId.toString());
		this.sessionId = sessionId;
		boolean override = false;
		try {
			if (this.settings.getBool(sessionId, "StartingNumOverride")) {
				override = true;
				LOGGER.info("StartingNumOverride set to true. "
						+ "Program will use the specified sequence nums.");
				int startSenderNum = this.settings.getInt(sessionId, "StartingSenderNum");
				int startTargetNum = this.settings.getInt(sessionId, "StartingTargetNum");
				Session currSession = Session.lookupSession(sessionId);
				currSession.setNextSenderMsgSeqNum(startSenderNum);
				currSession.setNextTargetMsgSeqNum(startTargetNum);
				LOGGER.info("Starting sequence number set. "
						+ "StartingNumOverride will be set to N.");
				this.settings.setBool(sessionId, "StartingNumOverride", false);
				Main.updateConfig(settings);
			}
		} catch (ConfigError configError) {
			if (override) {
				LOGGER.info("StartingNumOverride set but "
						+ "sequence numbers cannot be found."
						+ "Program will use either previous sequence numbers "
						+ "or restart at 1.");
			} else {
				LOGGER.debug("No start sequence number override specified.");
			}
		} catch (FieldConvertError fieldError) {
			LOGGER.info("Start sequence numbers set "
					+ "but cannot be read as an integer! "
					+ "Program will use either previous sequence numbers "
					+ "or restart at 1.");
		} catch (IOException e) {
			LOGGER.error("IOException encountered! Error trace printed below.", e);
		}
		try {
			this.pollForTrades = this.settings.getBool(sessionId, "PollForTrades");
			if (!this.pollForTrades) {
				LOGGER.info("PollForTrades set to N. Program will not poll the database for new trades.");
			}
		} catch (ConfigError configError) {
			LOGGER.info("PollForTrades setting not found. Defaulting to true.");
		} catch (FieldConvertError fieldError) {
			LOGGER.warn("PollForTrades setting specified but could not be read correctly! Defaulting to true.");
		}
	}

	/**
	 * QuickFIX/J callback method for when a session is logged in.
	 */
	@Override
	public void onLogon(SessionID sessionId) {
		LOGGER.info("ID: {}: Session logged in.", sessionId.toString());
	}

	/**
	 * QuickFIX/J callback method for when a session is logged out.
	 */
	@Override
	public void onLogout(SessionID sessionId) {
		LOGGER.info("ID: {}: Session logged out.", sessionId.toString());
	}

	/**
	 * QuickFIX/J callback method for when an administrative message (messages
	 * not sent explicitly by this application, basically) is about to be sent.
	 * If the message is a log on message, this method will remove the 141 tag,
	 * which is not supported by Broadridge. 
	 */
	@Override
	public void toAdmin(Message message, SessionID sessionId) {
		try {
			// remove ResetSeqNumFlag field for logon message, as Broadridge
			// doesn't accept this flag
			if (message.getHeader().getString(35).equals(MsgType.LOGON)) {
				message.removeField(141);
			}
		} catch (FieldNotFound fieldError) {
			LOGGER.debug("Could not find message type. Error log printed below.", fieldError);
		}
		LOGGER.debug("ID: {}: Sending admin message: {}", sessionId.toString(), message.toString());
	}

	/**
	 * QuickFIX/J callback method for when an administrative message is received
	 * from the connection counterpart.
	 */
	@Override
	public void fromAdmin(Message message, SessionID sessionId)
			throws FieldNotFound, IncorrectDataFormat, IncorrectTagValue, RejectLogon {
		LOGGER.debug("ID: {}: Admin message received: {}", sessionId.toString(), message.toString());
	}

	/**
	 * QuickFIX/J callback method for when an application message (messages that
	 * this app is sending) is about to be transmitted to the connection
	 * counterpart.
	 */
	@Override
	public void toApp(Message message, SessionID sessionId) throws DoNotSend {
		LOGGER.debug("ID: {}: Sending app message: {}", sessionId.toString(), message.toString());
	}

	/**
	 * QuickFIX/J callback method for when an application message is received
	 * from the connection counterpart. This method will insert the message,
	 * which should be an acknowledgement or non-acknowledgement from Gems,
	 * into the database (if the application is set to connect with the DB).
	 */
	@Override
	public void fromApp(Message message, SessionID sessionId)
			throws FieldNotFound, IncorrectDataFormat, IncorrectTagValue, UnsupportedMessageType {
		LOGGER.debug("ID: {}: App message received: {}", sessionId.toString(), message.toString());
		// only insert if app is set to connect with DB
		if (connect) {
			// checks to see if the connector currently designated for inserting
			// is still good
			if (this.sources[this.insertConnectorIndex] == null) {
				this.insertConnectorIndex = getFirstConnector();
				if (this.insertConnectorIndex == -1) {
					LOGGER.error("Program failed to insert a message into GEMS ACK/NACK table, "
							+ "as all of its connectors have been removed! "
							+ "Program will exit immediately. "
							+ "The message that failed to insert is {}.", message.toRawString());
					catastrophicFailure();
				}
			}
			int insertResult = this.sources[this.insertConnectorIndex].insertGemsMsg(message.toRawString());
			if (insertResult != -1) {
				LOGGER.debug("Message inserted into GEMS ACK/NACK table.");
			} else {
				LOGGER.error("Program failed to insert message into GEMS ACK/NACK table! "
						+ "Program will close all SQL connections and then exit immediately. "
						+ "The message that failed to insert is {}.", message.toRawString());
				catastrophicFailure();
			}
		}
	}

	/**
	 * Finds the first connector in the SQLConnector list that's not null
	 * and returns its index.
	 * 
	 * @return first instance of SQLConnector in the list of polling
	 * sources this object has. -1 if the list only has null values.
	 */
	private int getFirstConnector() {
		for (int i = 0; i < this.sources.length; i++) {
			if (this.sources[i] != null) {
				return i;
			}
		}
		return -1;
	}

	/**
	 * Main polling method. Polls all trade sources according to the
	 * polling interval.
	 * <p>
	 * If a trade source failed to poll, method will drop the trade source.
	 * <br>
	 * If the method failed to update a trade's process, it will
	 * drop the trade source.
	 * <br>
	 * If the method failed to send a message, it will stop the program entirely.
	 */
	public void poll() {
		this.running = true;
		boolean pollingLogged = false;
		// connect connectors to database if app is set to connect
		while (running) {
			// only poll if the application is:
			//   1. Set to connect to database.
			//   2. Set to poll the database.
			//   3. Logged on.
			if (this.connect && pollForTrades && Session.lookupSession(this.sessionId).isLoggedOn()) {
				// one time logging to indicate program is polling the database
				if (!pollingLogged) {
					LOGGER.info("Program now polling for trades.");
					pollingLogged = true;
				}
				// variable for keeping track of how many sources were polled
				int polledSources = 0;
				boolean stopAll = false;
				for (int i = 0; i < this.sources.length && !stopAll; i++) {
					SQLConnector source = this.sources[i];
					if (source != null) {
						polledSources++;
						int[] trades = source.checkForNewTrades();
						if (trades != null) {
							boolean errorEncountered = false;
							boolean tradesFoundLogged = false;
							for (int j = 0; j < trades.length && !errorEncountered; j++) {
								int tradeId = trades[j];
								if (!tradesFoundLogged) {
									tradesFoundLogged = true;
									LOGGER.debug("Trades found! Processing...");
								}
								String tradeMsg = source.getFIXMsg(tradeId);
								if (tradeMsg != null) {
									if (sendMsg(tradeMsg)) {
										int updateResult = source.updateProcessStatus(tradeId, LocalDateTime.now());
										if (updateResult == -1) {
											LOGGER.error("Program failed to update trade process status! "
													+ "The trade update that failed has the ID {}. "
													+ "Program will stop polling {}.", tradeId, source.getSourceTable());
											errorEncountered = true;
										}
									} else {
										LOGGER.error("Program failed to send message to engine! Check logging for possible causes."
												+ "Program will stop running. Last message: {}.", tradeMsg);
										errorEncountered = true;
										stopAll = true;
									}
								} else {
									LOGGER.error("Program failed to transform trade info into FIX message. "
											+ "Check logging above to see the error. "
											+ "The trade that failed has the ID {}."
											+ "Program will continue running, but may encounter the same issues.", tradeId);
								}
								// If app failed to send msg, stop the app.
								// If it just failed to update status, remove
								// the troubled connector from polling list.
								if (stopAll) {
									close();
								} else if (errorEncountered) {
									this.sources[i] = null;
								}
							}
						} else {
							LOGGER.error("Program failed to poll database for new trades. "
									+ "Check logging above to see the error. ");
							this.sources[i] = null;
							if (this.insertConnectorIndex == i) {
								this.insertConnectorIndex = getFirstConnector();
							}
						}
					}
				}
				if (polledSources == 0) {
					LOGGER.error("Program is supposed to poll but none of the sources could be polled! "
							+ "Check logging for possible causes. "
							+ "Program will exit.");
					close();
				}
			}
			// only go to sleep application is still running
			if (this.running) { 
				try {
					Thread.sleep(this.pollingInterval);
				} catch (InterruptedException sleepError) {
					LOGGER.warn("Error encountered trying to sleep! Error log printed below. "
							+ "Program will keep running.", sleepError);
				}
			}
		}
	}
	
	/**
	 * Sends the message to the connection counterpart.
	 * @param rawMsg the FIX message to be sent in the form of a string.
	 * @return true if the message is given to QuickFIX/J engine for sending,
	 * false if otherwise, which may be caused by no logged in sessions.
	 * @throws NumberFormatException
	 * 
	 * NOTE: since the QuickFIX/J engine sends messages asynchronously, just
	 * because this method returns true doesn't mean the message is sent.
	 */
	public boolean sendMsg(String rawMsg) throws NumberFormatException{
		Message msg = processMsg(rawMsg);
		try {
			return Session.sendToTarget(msg, this.sessionId);
		} catch (SessionNotFound sessionErr) {
			LOGGER.error("Session could not be found! Error trace printed below.", sessionErr);
			return false;
		}
	}
	
	// strings used for the processMsg method
	private static final String BEGIN_STRING = "8";
	private static final String MSG_LENGTH = "9";
	private static final String CHECKSUM = "10";
	private static final String PADDING = " ";
	private static final String SEPARATOR = "\u0001";
	private static final String EQUAL_SIGN = "=";
	private static final String EMPTY_STRING = "";
	
	/**
	 * Helper method for processing a FIX message from a string into a
	 * QuickFIX/J message object.
	 * 
	 * Since we only send execution reports to Broadridge, this method will
	 * assume the given message is an execution report (tag 35=8).
	 * @param rawMsg the FIX message in string format.
	 * @return the given FIX message as a QuickFIX/J message object.
	 * @throws NumberFormatException
	 */
	public static Message processMsg(String rawMsg) throws NumberFormatException{
		// separate the message into an array of its fields
		String[] msgFields = rawMsg.split(SEPARATOR);
		Message msg = new ExecutionReport();
		for (int i = 0; i < msgFields.length; i++) {
			// separate tag and value of each field
			String[] field = msgFields[i].split(EQUAL_SIGN, 2);
			// only add the field to the message if the split method has found an =
			if (field.length == 2) {
				StringField fieldToAdd;
				// replace empty value with a space
				if (field[1].equals(EMPTY_STRING)) {
					fieldToAdd = new StringField(Integer.parseInt(field[0]), PADDING);
				} else {
					fieldToAdd = new StringField(Integer.parseInt(field[0]), field[1]);
				}
				// add normal fields to the message body while special fields are added to the header
				switch (field[0]) {
					case BEGIN_STRING: break;
					case MSG_LENGTH: break;
					case CHECKSUM: break;
					default: msg.setField(fieldToAdd);
				}
			}
		}
		return msg;
	}
	
	/**
	 * Indicates to the app that it is to shutdown the next time it polls.
	 */
	public void close() {
		this.running = false;
	}
	
	/**
	 * Immediately shuts down the app.
	 */
	public void catastrophicFailure() {
		LOGGER.error("Catastrophic error encountered! System will immediately exit to minimize data loss.");
		System.exit(1);
	}
	
	@Override
	public String toString() {
		return "FixApp [sources=" + Arrays.toString(sources) + ", connect=" + connect + ", sessionId=" + sessionId
				+ ", pollForTrades=" + pollForTrades + ", pollingInterval=" + pollingInterval + ", running=" + running
				+ "]";
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + Arrays.hashCode(sources);
		result = prime * result
				+ Objects.hash(connect, insertConnectorIndex, pollForTrades, pollingInterval, running, sessionId);
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		FixApp other = (FixApp) obj;
		return connect == other.connect && insertConnectorIndex == other.insertConnectorIndex
				&& pollForTrades == other.pollForTrades && pollingInterval == other.pollingInterval
				&& running == other.running && Objects.equals(sessionId, other.sessionId)
				&& Arrays.equals(sources, other.sources);
	}
}
