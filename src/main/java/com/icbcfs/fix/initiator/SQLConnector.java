/**
 * Connector class for interfacing with the database.
 */
package com.icbcfs.fix.initiator;

import java.sql.PreparedStatement;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Arrays;
import java.util.Objects;
import java.util.ArrayDeque;
import java.time.LocalDateTime;

import org.slf4j.LoggerFactory;
import org.slf4j.Logger;
import com.microsoft.sqlserver.jdbc.SQLServerDataSource;
import com.microsoft.sqlserver.jdbc.SQLServerException;

import com.fasterxml.jackson.dataformat.yaml.YAMLMapper;
import com.fasterxml.jackson.core.exc.StreamReadException;
import com.fasterxml.jackson.databind.DatabindException;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;

public class SQLConnector {
	private static final Logger LOGGER = LoggerFactory.getLogger(SQLConnector.class);
	private static final String GEMS_TABLE = "dbo.GemsAckNACK_staging";
	private static final String[] GEMS_COLUMNS = new String[]{
		"message",
		"MessageProcessStatus",
		"ConfigValue_src",
		"inserteddatetime"
	};
	private static final String CONFIG_VALUE = "FIX_JAVA";
	private static final String TRADE_ID_COLUMN = "TradeID";
	private static final String GET_TRADE_PROC = "dbo.GET_All_trade_to_gems_realtime_fixedincome";
	private String insertQuery;
	private String checkNewTradesQuery;
	private String updateQuery;
	private String transformQuery;
	private SQLServerDataSource ds;
	private String sourceTable;
	private int maxConnRetries;
	
	private SQLConnector(SQLConfig config, int maxConnRetries) {
		this.ds = new SQLServerDataSource();
		this.ds.setIntegratedSecurity(true);
		this.ds.setServerName(config.server);
		this.ds.setPortNumber(config.port);
		this.ds.setDatabaseName(config.database);
		this.ds.setTrustServerCertificate(true);
		this.sourceTable = config.sourceTable;
		this.maxConnRetries = maxConnRetries;

		// construct strings used for queries
		String[] placeholderArr = new String[GEMS_COLUMNS.length];
		Arrays.fill(placeholderArr, "?");
		this.insertQuery =
				"INSERT INTO %s (%s)".formatted(
						GEMS_TABLE, String.join(", ", GEMS_COLUMNS)
				) + "VALUES (%s)".formatted(String.join(", ", placeholderArr));
		this.checkNewTradesQuery = "{call %s(%s)};".formatted(GET_TRADE_PROC, this.sourceTable);
		this.updateQuery =
				"UPDATE %s ".formatted(this.sourceTable)
				+ "SET TradeProcessStatus = 1, MQSendTime = ? "
				+ "WHERE %s = ?".formatted(TRADE_ID_COLUMN);
		this.transformQuery = "{? = call %s(?)}".formatted(config.transformFunction);
	}
	
	/**
	 * Constructor method for creating the SQLConnector from the given config
	 * file. The file should be a YAML file.
	 * @param configPath the path leading to the configuration file.
	 * @param maxConnRetries how many retries the connector will attempt in the
	 * case that a database interaction fails.
	 * @return a SQLConnector with the given configs, null if errors occurred.
	 */
	public static SQLConnector getConnector(String configPath, int maxConnRetries) {
		ObjectMapper mapper = new YAMLMapper();
		SQLConfig config = null;
		try {
			config = mapper.readValue(new File(configPath), SQLConfig.class);
			if (!config.sourceTable.matches("\\w+")) {
				LOGGER.error("Source table name cannot be accepted! "
						+ "Check config {}.", configPath);
				config = null;
			}
		} catch (FileNotFoundException fileError) {
			LOGGER.error("Config file could not be found! Error log printed below.", fileError);
		} catch (StreamReadException streamError) {
			LOGGER.error("Error occurred while trying to read config file! Error log printed below.", streamError);
		} catch (DatabindException bindError) {
			LOGGER.error("Error occurred while trying to bind values read to result class! Error log printed below.", bindError);
		} catch (IOException ioError) {
			LOGGER.error("IOException occurred! Error log printed below.", ioError);
		}
		if (config == null) {
			return null;
		} else {
			return new SQLConnector(config, maxConnRetries);
		}
	}

	/**
	 * Checks the table this connector is configured with to see if there's
	 * unprocessed trades that's not blocked. Does not retry if the method
	 * fails to check.
	 * @return an array with ID's of trades waiting to be sent, an empty array
	 * if there's no trades waiting to be sent, or null if there's any errors.
	 */
	public int[] checkForNewTrades() {
		return checkForNewTrades(0);
	}
	
	/**
	 * Checks the table this connector is configured with to see if there's
	 * unprocessed trades that's not blocked. The method will retry if errors
	 * occur, up to the given retryAttempts.
	 * @param retryAttempts max number of attempts the method will retry for.
	 * @return an array with ID's of trades waiting to be sent, an empty array
	 * if there's no trades waiting to be sent, or null if there's any errors.
	 */
	public int[] checkForNewTrades(int retryAttempts) {
		int[] output = null;
		try (Connection conn = this.ds.getConnection()) {
			try (ResultSet rs = conn.createStatement().executeQuery(this.checkNewTradesQuery)) {
				output = parseResult(rs);
			} catch (SQLException executeError) {
				LOGGER.error("Error occurred while trying to execute polling statement! Error log printed below.", executeError);
			}
		} catch (SQLServerException connError) {
			LOGGER.error("Could not connect to the database for polling! Error log printed below.", connError);
		} catch (SQLException closeError) {
			LOGGER.info("Error occurred while trying to close the connection for polling.", closeError);
		}
		if (output == null && retryAttempts < this.maxConnRetries) {
			LOGGER.warn("Program failed to poll trade source {}. Retrying...", this.sourceTable);
			output = checkForNewTrades(++retryAttempts);
		} else if (output == null) {
			LOGGER.error("Program could not poll database within retry limits. Check logging for possible causes. "
					+ "Trade source that failed: {}.", this.sourceTable);
		}
		return output;
	}
	
	/**
	 * Helper method for parsing the given result set and extract the ID's of
	 * trades, returning it in an int array.
	 * @param rs the result set this method will parse.
	 * @return int array containing the trade ID's from the given result set,
	 * an empty int array if the result set is empty, or null if errors
	 * occurred.
	 */
	private int[] parseResult(ResultSet rs) {
		int[] output = null;
		ArrayDeque<Integer> tradeIds = new ArrayDeque<>();
		try {
			while (rs.next()) {
				tradeIds.offer(Integer.valueOf(rs.getInt(TRADE_ID_COLUMN)));
			}
		} catch (SQLException rsError) {
			LOGGER.error("Error occurred while trying to iterate result set! Error log printed below. "
					+ "Program will send the trades it has gathered so far.", rsError);
		}
		output = new int[tradeIds.size()];
		for (int i = 0; i < output.length; i++) {
			output[i] = tradeIds.poll();
		}
		return output;
	}

	/**
	 * Updates the database to indicate the trade with the given trade ID is
	 * processed at the given time. Does not retry if method fails to update.
	 * @param tradeID the ID of the trade that was sent.
	 * @param timestamp the time at which the trade was sent.
	 * @return the number of rows the update changed (which should always be 1),
	 * -1 if any error occurred.
	 */
	public int updateProcessStatus(int tradeID, LocalDateTime timestamp) {
		return updateProcessStatus(tradeID, timestamp, 0);
	}
	
	/**
	 * Updates the database to indicate the trade with the given trade ID is
	 * processed at the given time. If errors occur, this method will retry
	 * for up to the given retry attempts .
	 * @param tradeID the ID of the trade that was sent.
	 * @param timestamp the time at which the trade was sent.
	 * @return the number of rows the update changed (which should always be 1),
	 * -1 if any error occurred.
	 */
	public int updateProcessStatus(int tradeID, LocalDateTime timestamp, int retryAttempts) {
		int output = -1;
		try (Connection conn = this.ds.getConnection()) {
			try (PreparedStatement updateStatement = conn.prepareStatement(
						this.updateQuery)
			) {
				java.sql.Timestamp sendTime = java.sql.Timestamp.valueOf(timestamp);
				updateStatement.setTimestamp(1, sendTime);
				updateStatement.setInt(2, tradeID);
				output = updateStatement.executeUpdate();
			} catch (SQLException updateError) {
				LOGGER.error("Could not execute update statement! Error log printed below.", updateError);
			}
		} catch (SQLServerException connError) {
			LOGGER.error("Could not connect to the database for trade processing updates! "
					+ "Error log printed below.", connError);
		} catch (SQLException closeError) {
			LOGGER.info("Error occurred while trying to close connection for trade updates.", closeError);
		}
		if (output == -1 && retryAttempts < this.maxConnRetries) {
			LOGGER.warn("Program failed to update status for trade {}. Retrying...", tradeID);
			output = updateProcessStatus(tradeID, timestamp, ++retryAttempts);
		} else if (output == -1) {
			LOGGER.error("Program failed to update trade status within retry limits. "
					+ "Check logging for possible causes. "
					+ "Trade status that failed to update: {}, processed at time {}.", tradeID, timestamp);
		}
		return output;
	}

	/**
	 * Calls the database to transform the trade with the given ID into a FIX
	 * message. Does not retry if method fails to transform trade.
	 * @param tradeID the ID of the trade to be transformed.
	 * @return the FIX message of the trade as a string, null if errors
	 * occurred.
	 */
	public String getFIXMsg(int tradeID) {
		return getFIXMsg(tradeID, 0);
	}
	
	/**
	 * Calls the database to transform the trade with the given ID into a FIX
	 * message. If errors occur, this method will retry for up to the specified
	 * retry attempts.
	 * @param tradeID the ID of the trade to be transformed.
	 * @return the FIX message of the trade as a string, null if errors
	 * occurred.
	 */
	public String getFIXMsg(int tradeID, int retryAttempts) {
		String output = null;
		try (Connection conn = this.ds.getConnection()) {
			try (CallableStatement transformStatement =
					conn.prepareCall(this.transformQuery)
			) {
				transformStatement.setInt(2, tradeID);
				transformStatement.registerOutParameter(1, java.sql.Types.NVARCHAR);
				transformStatement.execute();
				output = transformStatement.getNString(1);
			} catch (SQLException transformError) {
				LOGGER.error("Could not transform trade into FIX message! "
						+ "Error log printed below.", transformError);
			}
		} catch (SQLServerException connError) {
			LOGGER.error("Could not connect to the database for getting FIX messages! "
					+ "Error log printed below.", connError);
		} catch (SQLException closeError) {
			LOGGER.info("Error occurred while trying to close the connection for getting FIX message.", closeError);
		}
		if (output == null && retryAttempts < this.maxConnRetries) {
			LOGGER.warn("Program failed to get FIX message for trade {}. Retrying...", tradeID);
			output = getFIXMsg(tradeID, ++retryAttempts);
		} else if (output == null) {
			LOGGER.error("Program failed to acquire FIX message within retry limits. "
					+ "Check logging for possible causes. "
					+ "Trade that failed: {}.", tradeID);
		}
		return output;
	}
	
	/**
	 * Inserts the given message into the Gems acknowledgments staging table.
	 * Does not retry if errors occur.
	 * @param gemsMsg the message to be inserted.
	 * @return the number of rows inserted (which should always be 1), -1 if
	 * errors occurred.
	 */
	public int insertGemsMsg(String gemsMsg) {
		return insertGemsMsg(gemsMsg, 0);
	}

	/**
	 * Inserts the given message into the Gems acknowledgments staging table.
	 * If errors occur, this method will retry for up to the given retry
	 * attempts.
	 * @param gemsMsg the message to be inserted.
	 * @return the number of rows inserted (which should always be 1), -1 if
	 * errors occurred.
	 */
	public int insertGemsMsg(String gemsMsg, int retryAttempts) {
		int output = -1;
		try (Connection conn = this.ds.getConnection()) {
			try (PreparedStatement insertStatement = 
					conn.prepareStatement(this.insertQuery)
			) {
				insertStatement.setNString(1, gemsMsg);
				insertStatement.setInt(2, 0);
				insertStatement.setNString(3, CONFIG_VALUE);
				insertStatement.setTimestamp(4, Timestamp.valueOf(LocalDateTime.now()));
				output = insertStatement.executeUpdate();
			} catch (SQLException insertError) {
				LOGGER.error("Could not insert Gems acknowledgement! "
						+ "Error log printed below.", insertError);
			}
		} catch (SQLServerException connError) {
			LOGGER.error("Could not connect to the database for inserting Gems acknowledgements! "
					+ "Error log printed below.", connError);
		} catch (SQLException closeError) {
			LOGGER.info("Error occurred while trying to close the connection for inserting Gems acknowledgements.", closeError);
		}
		if (output == -1 && retryAttempts < this.maxConnRetries) {
			LOGGER.warn("Program failed to insert a Gems acknowledgement. Retrying...");
			output = insertGemsMsg(gemsMsg, ++retryAttempts);
		} else if (output == -1) {
			LOGGER.error("Program failed to insert Gems acknowledgements within retry limits. "
					+ "Check logging for possible causes. "
					+ "Message that failed to be inserted: {}.", gemsMsg);
		}
		return output;
	}

	/**
	 * Returns the table this SQLConnector instance uses as its trade source.
	 * @return
	 */
	public String getSourceTable() {
		return this.sourceTable;
	}
	
	@Override
	public int hashCode() {
		return Objects.hash(maxConnRetries, sourceTable, transformQuery);
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		SQLConnector other = (SQLConnector) obj;
		return maxConnRetries == other.maxConnRetries && Objects.equals(sourceTable, other.sourceTable)
				&& Objects.equals(transformQuery, other.transformQuery);
	}

	@Override
	public String toString() {
		return "SQLConnector [sourceTable=" + sourceTable + ", maxConnRetries=" + maxConnRetries + "]";
	}
}
