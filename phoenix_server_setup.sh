#!/bin/bash

# This script sets up an Ubuntu server for a Phoenix app.

echo "Updating package list..."
sudo apt update

echo "Checking Erlang..."
if command -v erl > /dev/null; then
    echo "Erlang is already installed."
else
    echo "Installing Erlang..."
    sudo apt install -y erlang
fi

echo "Checking Elixir..."
if command -v elixir > /dev/null; then
    echo "Elixir is already installed."
else
    echo "Installing Elixir..."
    sudo apt install -y elixir
fi

echo "Checking Mix..."
mix local.hex

echo "Checking Postgres..."
if dpkg -s postgresql &> /dev/null; then
    echo "PostgreSQL is already installed."
else
    echo "Installing PostgreSQL..."
    sudo apt install -y postgresql
fi

echo Setting the default user "postgres" password to "postgres"
su - postgres -c "psql -c \"ALTER USER postgres PASSWORD 'postgres';\""

echo "Checking for 'phoenix' database..."
su - postgres -c "psql -lqt | cut -d \| -f 1 | grep -qw phoenix || psql -c \"CREATE DATABASE phoenix;\""

# Optionally, inform the user about installing Node.js and npm for assets management in Phoenix
# Uncomment the line below if you want to install Node.js and npm
# echo "Installing Node.js and npm for assets management in Phoenix..."
# sudo apt install -y nodejs npm

echo "Setup complete!"
