#!/bin/bash

_SHELL='/bin/bash'
EXECAPP="${EXECAPP:-$_SHELL}"

# Default the TZ environment variable to UTC.
TZ=${TZ:-UTC}
export TZ

# Set environment variable that holds the Internal Docker IP
INTERNAL_IP=$(ip route get 1 | awk '{print $(NF-2);exit}')
export INTERNAL_IP

# set this variable, dotnet needs it even without it it reports to `dotnet --info` it can not start any aplication without this
export DOTNET_ROOT=/usr/share/

# print the dotnet version on startup
printf "\033[1m\033[33mcontainer@pelican~ \033[0mdotnet --version\n"
dotnet --version

mkdir -p /mnt/server

# Switch to the container's working directory
#cd /home/container || exit 1
cd /mnt/server || exit 1

#Installing the server
git clone https://github.com/ss14Starlight/space-station-14.git
cd space-station-14
mv * ../
cd ..
rm space-station-14
echo "Running RUN_THIS.py"
python3 RUN_THIS.py || py RUN_THIS.py || python RUN_THIS.py || /usr/bin/python3 RUN_THIS.py || /usr/bin/python RUN_THIS.py

echo "Building server"
dotnet build Content.Packaging --configuration Release
dotnet run --project Content.Packaging server --hybrid-acz --platform linux-x64

# Move compiled files to accessible server folder.
#mkdir -p /mnt/server
#mv release/ /mnt/server/

# Replace Startup Variables
MODIFIED_STARTUP=$(echo -e ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')
echo -e ":/home/container$ ${MODIFIED_STARTUP}"

# Run the Server
eval ${MODIFIED_STARTUP}