/**
 * Entry point for starting up the application.
 */
package com.icbcfs.fix.initiator;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Arrays;
import java.io.PrintWriter;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import quickfix.Initiator;
import quickfix.ConfigError;
import quickfix.DefaultMessageFactory;
import quickfix.FieldConvertError;
import quickfix.LogFactory;
import quickfix.FileStoreFactory;
import quickfix.MessageFactory;
import quickfix.MessageStoreFactory;
import quickfix.SLF4JLogFactory;
import quickfix.SessionSettings;
import quickfix.SocketInitiator;

public class Main {
	private static final String CONFIG_PATH = "config/initiator.cfg";

	// LOGGER config file: src/main/resources/config/log4j2.yaml
	private final static Logger LOGGER = LoggerFactory.getLogger(Main.class);

	/**
	 * Main entry point.
	 * @param args command line arguments passed in; not used.
	 */
	public static void main(String[] args) {
		LOGGER.info("Program started.");
		mainProgram();
		LOGGER.info("Program Terminated.");
	}

	/**
	 * Main program for loading the configs, instantiating the necessary
	 * classes, and launching the polling method of the app that will check
	 * the database for trades.
	 */
	public static void mainProgram() {
		// load settings from config
		SessionSettings settings = null;
		LOGGER.info("Loading config file from location {}...", CONFIG_PATH);
		try (FileInputStream configFile = new FileInputStream(CONFIG_PATH)) {
			settings = new SessionSettings(configFile);
			LOGGER.info("Config loaded successfully.");
		} catch (FileNotFoundException fileError) {
			LOGGER.error("Config file could not be found! Make sure the file is located at {}.", CONFIG_PATH, fileError);
		} catch (IOException ioError) {
			LOGGER.error("IO error! Error trace printed below.", ioError);
		} catch (ConfigError configError) {
			LOGGER.error("Config has errors! Error trace printed below.", configError);
		}

		boolean connect = true;
		String[] tradeSources = null;

		// stop initialization of the program if config isn't loaded correctly.
		if (settings == null) {
			LOGGER.error("Settings aren't properly loaded! "
					+ "Check logging above for possible causes.");
			return;
		}
		LOGGER.info("Reading database connection setting...");
		try {
			connect = settings.getBool("ConnectToDB");
			LOGGER.info("Database connection setting found: {}", connect);
		} catch (ConfigError keyError) {
			LOGGER.info("ConnectToDB setting not found. Will default to true.");
		} catch (FieldConvertError fieldError) {
			LOGGER.info("ConnectToDB setting cannot be converted to boolean. Will default to true.");
		}
		if (connect) {
			LOGGER.info("Loading trade source configs...");
			try {
				File tradeSourceDir = new File(settings.getString("TradeSourcesFolder"));
				tradeSources = tradeSourceDir.list();
				if (tradeSources == null) {
					LOGGER.error("Could not find trade source config files! "
							+ "Make sure that the SQL connection configs for trade sources are located within the folder "
							+ "specified by the setting 'TradeSourcesFolder'. "
							+ "Program will not start.");
				} else {
					for (int i = 0; i < tradeSources.length; i++) {
						tradeSources[i] = settings.getString("TradeSourcesFolder") + "/" + tradeSources[i];
					}
					LOGGER.info("Loaded trade source configs: {}",
							Arrays.toString(tradeSources));
				}
			} catch (ConfigError configError) {
				LOGGER.error("TradeSourcesFolder path cannot be found! "
						+ "Program will not start.", configError);
			}
		}

		// stop if app is set to connect but can't load tradeSources.
		if (tradeSources == null && connect) {
			LOGGER.error("Program set to connect with DB but no DB configs "
					+ "can be loaded! Check logging above for possible causes.");
			return;
		}
		// create main app
		LOGGER.info("Creating FIX application...");
		FixApp mainApp = FixApp.getApp(settings, tradeSources, connect);
		if (mainApp == null) {
			LOGGER.error("FIX app couldn't be created! Check logging above "
					+ "for possible causes.");
			return;
		}
		try {
			LOGGER.info("Creating FIX initiator...");
			// load settings, create other dependency objects for the initiator
			MessageStoreFactory storeFactory = new FileStoreFactory(settings);
			LogFactory logFactory = new SLF4JLogFactory(settings);
			MessageFactory messageFactory= new DefaultMessageFactory();

			// create initiator
			Initiator initiator = new SocketInitiator (mainApp, storeFactory, settings, logFactory, messageFactory);
			LOGGER.info("Initiator created: {}", initiator);
			
			// shutdown handling to properly close everything and logout
			Thread shutdownThread = new Thread() {
				public void run() {
					initiator.stop();
					mainApp.close();
				}
			};
			Runtime.getRuntime().addShutdownHook(shutdownThread);
			// start initiator
			LOGGER.info("Starting initiator and logging on...");
			initiator.start();
			LOGGER.info("Initiator started.");
			try {
				LOGGER.info("Starting polling of database...");
				mainApp.poll();
			} catch (Exception e) {
				LOGGER.error("Some error happened during polling! Error trace printed below.", e);
			}
			initiator.stop();
			mainApp.close();
		} catch (ConfigError e) {
			LOGGER.error("Config file has some error! Error trace printed below.", e);
		} catch (Exception e) {
			LOGGER.error("Some error happened! Error trace printed below.", e);
		}
	}
	
	/**
	 * Helper method for updating the config after the starting sequence numbers
	 * have been overridden.
	 * @param settings the settings to be saved.
	 */
	public static void updateConfig(SessionSettings settings) {
		try (PrintWriter writer = new PrintWriter(new File(CONFIG_PATH))) {
			settings.toString(writer);
		} catch (FileNotFoundException fileError) {
			LOGGER.warn("Config file could not be updated! "
					+ "Program will keep running, "
					+ "but the config file will need manual updating. "
					+ "The updated config will be printed below, "
					+ "followed by the error trace.");
			LOGGER.warn("Updated config:\n{}", settings.toString(), fileError);
		}
	}
}