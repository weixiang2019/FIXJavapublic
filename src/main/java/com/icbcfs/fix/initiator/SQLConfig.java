/**
 * Config wrapper class for the SQLConnector.
 */
package com.icbcfs.fix.initiator;

import java.util.Objects;

public class SQLConfig {
	public String server;
	public int port;
	public String database;
	public String sourceTable;
	public String transformFunction;
	public int maxConnRetries = 3;
	
	@Override
	public String toString() {
		return "SQLConfig [server=" + server + ", port=" + port + ", database=" + database + ", sourceTable="
				+ sourceTable + ", transformFunction=" + transformFunction + ", maxConnRetries=" + maxConnRetries + "]";
	}

	@Override
	public int hashCode() {
		return Objects.hash(database, maxConnRetries, port, server, sourceTable, transformFunction);
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		SQLConfig other = (SQLConfig) obj;
		return Objects.equals(database, other.database) && maxConnRetries == other.maxConnRetries
				&& Objects.equals(server, other.server) && Objects.equals(sourceTable, other.sourceTable)
				&& Objects.equals(transformFunction, other.transformFunction);
	}
	
}
