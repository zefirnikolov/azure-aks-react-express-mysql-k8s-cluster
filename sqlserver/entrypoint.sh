#!/usr/bin/env bash
set -euo pipefail

# Start SQL Server in the background
/opt/mssql/bin/sqlservr &
SQL_PID=$!

# Function: wait for SQL to be ready
wait_for_sql() {
  echo "Waiting for SQL Server to be available..."
  for i in {1..60}; do
    if /opt/mssql-tools18/bin/sqlcmd -S localhost -U SA -P "$MSSQL_SA_PASSWORD" -C -Q "SELECT 1" > /dev/null 2>&1; then
      echo "SQL Server is up."
      return 0
    fi
    sleep 2
  done
  echo "Timed out waiting for SQL Server to start." >&2
  return 1
}

# Validate required env vars
if [[ -z "${MSSQL_SA_PASSWORD:-}" ]]; then
  echo "MSSQL_SA_PASSWORD must be set as an environment variable." >&2
  exit 1
fi

: "${APP_DB_NAME:=mydb}"
: "${APP_DB_LOGIN:=cash100m}"
: "${APP_DB_PASSWORD:=ChangeMe!12345FFFwecrgrgaefwrb}"

wait_for_sql

# Run the initialization script (idempotent)
/opt/mssql-tools18/bin/sqlcmd   -S localhost   -U SA   -P "$MSSQL_SA_PASSWORD"   -C   -v DBNAME="$APP_DB_NAME" APPLOGIN="$APP_DB_LOGIN" APPPASSWORD="$APP_DB_PASSWORD"   -i /usr/src/app/init.sql

# Bring SQL Server process to foreground
wait $SQL_PID
