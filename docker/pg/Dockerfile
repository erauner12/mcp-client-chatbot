# Use the official PostgreSQL image as a base
FROM postgres:15-alpine

# Copy the initialization script to the Docker entrypoint directory
# Scripts in /docker-entrypoint-initdb.d are run on container startup
COPY init.sql /docker-entrypoint-initdb.d/

# Expose the default PostgreSQL port
EXPOSE 5432
