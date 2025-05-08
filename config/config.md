# Configurations

Configurations are divided into 2 sections: default configurations
and session specific configurations.

Default configurations are applied to all sessions.

Because of our system's setup, we have 2 sessions but run them as separate
applications.

## Definitions

The following table contains a brief description of what each configuration
is for. Some of them are used by the QuickFIX/J objects (indicated by
the [QF] tag), the rest are for this application.

| Config | Purpose |
| --- | --- |
| BeginString | [QF] FIX version |
| SocketConnectPort | [QF] connection port number |
| ValidateCheckSum | [QF] validate message checksum |
| EndTime | [QF] logout time |
| ReconnectInterval | [QF] time between reconnect attempts in seconds |
| FileStorePath | [QF] session info storage folder for QuickFIX/J |
| ConnectToDB | whether the application should be connected to the database    |
|             | or not. If set to Y, app will poll the DB for trades and store |
|             | ack/nacks. If set to N, app will only connect with Broadridge. |
| UseDataDictionary | [QF] whether the app will use a data dictionary or not |
| DBConnectionMaxRetries | if the application connects to DB, how many retries |
|                        | will it attempt before giving up.                   |
| TradeSourcesFolder | where config files for the trade sources are located |
| DisconnectOnError | [QF] whether the app disconnects on error or not |
| ConnectionType | [QF] whether the app is an initiator or acceptor |
| LogoutTimeout | [QF] number of seconds to wait for a logout response before |
|               | disconnecting.                                              |
| StartTime | [QF] Logon time |
| ValidateUserDefinedFields | [QF] whether the app checks user defined fields |
|                           | against the data dictionary or if they are in   |
|                           | messages they don't belong to or not.           |
| SocketConnecHost | [QF] IP of the host the app is connecting to |
| ValidateFieldsOutOfOrder | [QF] whether the app will validate fields order |
|                          | or not                                          |
| ValidateFieldsHaveValues | [QF] whether the app allows empty fields or not |
| TimeZone | [QF] time zone for the app |
| TimeStampPrecision | [QF] how precise should time be displayed |
| ResetOnLogout | [QF] whether sequence numbers are reset on logout or not |
| SLF4JLogHeartbeats | [QF] whether heartbeat messages are logged or not |
| PollingInterval | the time in ms that the app will sleep for between polls |
| HeartBtInt | [QF] the interval in seconds the app will use for heart beats |
| SenderCompID | [QF] the ID of the app |
| PollForTrades | whether the app polls the DB for trades or not. The app will |
|               | still write ack/nacks to DB if set to N.                     |
| TargetCompID | [QF] the ID of the host this app is connecting to |
