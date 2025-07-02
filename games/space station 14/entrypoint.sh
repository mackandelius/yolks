#!/bin/bash

# Wait for the container to fully initialize
sleep 1

# Default the TZ environment variable to UTC.
TZ=${TZ:-UTC}
export TZ

# Set environment variable that holds the Internal Docker IP
INTERNAL_IP=$(ip route get 1 | awk '{print $(NF-2);exit}')
export INTERNAL_IP

# Switch to the container's working directory
cd /home/container || exit 1


#Installing the server
git clone https://github.com/ss14Starlight/space-station-14.git
cd space-station-14
mv * ../
cd ..
rm space-station-14
echo "Running RUN_THIS.py"
python3 RUN_THIS.py

echo "Building server"
dotnet build Content.Packaging --configuration Release
dotnet run --project Content.Packaging server --hybrid-acz --platform linux-x64
