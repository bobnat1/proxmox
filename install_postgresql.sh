#!/bin/bash
# PostgreSQL Installation Script for LXC Container
# Run this script inside the postgres-container (ID: 209)

set -e

echo "=== PostgreSQL Installation Script ==="
echo "Installing PostgreSQL and dependencies..."

# Update package lists
apt update

# Install PostgreSQL and contrib package
apt install -y postgresql postgresql-contrib

# Enable and start PostgreSQL service
systemctl enable postgresql
systemctl start postgresql

# Wait for PostgreSQL to start
sleep 5

echo "=== Configuring PostgreSQL ==="

# Set password for postgres user
sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'postgres';"

# Create a database for general use
sudo -u postgres createdb appdb

# Configure PostgreSQL to accept connections from all IP addresses
PG_VERSION=$(sudo -u postgres psql -t -c "SELECT version();" | grep -oP '\d+\.\d+' | head -1)
PG_CONFIG_DIR="/etc/postgresql/$PG_VERSION/main"

# Backup original files
cp $PG_CONFIG_DIR/pg_hba.conf $PG_CONFIG_DIR/pg_hba.conf.backup
cp $PG_CONFIG_DIR/postgresql.conf $PG_CONFIG_DIR/postgresql.conf.backup

# Configure pg_hba.conf for remote connections
echo "# Allow connections from any IP with password authentication" >> $PG_CONFIG_DIR/pg_hba.conf
echo "host all all 0.0.0.0/0 md5" >> $PG_CONFIG_DIR/pg_hba.conf

# Configure postgresql.conf to listen on all addresses
sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" $PG_CONFIG_DIR/postgresql.conf

# Restart PostgreSQL to apply changes
systemctl restart postgresql

# Verify PostgreSQL is running
systemctl status postgresql --no-pager

echo "=== PostgreSQL Installation Complete ==="
echo ""
echo "PostgreSQL Details:"
echo "- Service: Running and enabled"
echo "- Port: 5432"
echo "- User: postgres"
echo "- Password: postgres"
echo "- Database: appdb (plus default postgres db)"
echo ""
echo "Connection examples:"
echo "- Local: psql -U postgres -d appdb"
echo "- Remote: psql -h <container_ip> -U postgres -d appdb"
echo ""
echo "To find this container's IP address:"
echo "  ip addr show | grep 'inet ' | grep -v '127.0.0.1'"