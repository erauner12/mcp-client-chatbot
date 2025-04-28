#!/bin/sh
# Exit immediately if a command exits with a non-zero status.
set -e

# Check if USE_FILE_SYSTEM_DB is true (or not set, assuming true is default)
# Only run SQLite migrations if using the filesystem DB.
if [ "$USE_FILE_SYSTEM_DB" = "true" ] || [ -z "$USE_FILE_SYSTEM_DB" ]; then
  echo "Running SQLite Drizzle migrations..."
  # Use pnpm to execute the script defined in package.json, ensuring correct context
  # Pass the config explicitly for clarity
  pnpm db:push --config=drizzle.config.ts
  echo "SQLite Drizzle migrations finished."
else
  echo "Skipping SQLite Drizzle migrations (USE_FILE_SYSTEM_DB is not true)."
  # If using Postgres, migrations might be handled differently or manually.
  # Add Postgres migration logic here if needed, e.g.:
  # echo "Running PostgreSQL Drizzle migrations..."
  # pnpm db:push --config=drizzle.config.ts
  # echo "PostgreSQL Drizzle migrations finished."
fi


# Execute the CMD passed to the docker run command (which should be `node server.js`)
echo "Starting application server..."
exec "$@"