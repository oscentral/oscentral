# Create osc-nodejs
FROM ubuntu:14.04

# update package sources
RUN apt-get -y update
RUN apt-get -y upgrade
# Install GIT Version Management & curl for file exchange & control 
RUN apt-get -y install git
RUN apt-get -y install build-essential libssl-dev curl
# GIT Clone NVM GitRepository 
RUN git clone https://github.com/creationix/nvm.git /.nvm
# Copy Content of nvm.sh to bashrc maybe we can call it later from there
RUN echo ". /.nvm/nvm.sh" >> /etc/bash.bashrc
# Use DirektSPEED nvm bash replacement for docker that calls nvm.sh in same command as nvm
ADD nvm /usr/local/bin/nvm
RUN chmod +x /usr/local/bin/nvm

# NVM with default node version installed
RUN /bin/bash -c 'nvm install v0.10.20 && nvm use v0.10.20 && nvm alias default v0.10.20 && ln -s /.nvm/v0.10.20/bin/node /usr/bin/node && ln -s /.nvm/v0.10.20/bin/npm /usr/bin/npm'
# forever for running node apps as daemons and automatically restarting on file changes
RUN npm install forever -g
# Clean up apt-cache so we have a more clean image
RUN apt-get clean -y
####################################################
# Create osc-nodejsdev
# start with our nodebase image
FROM dspeed/osc-nodejs

# grunt init to setup new node projects
RUN npm install grunt@master -g
RUN npm install grunt-cli -g
RUN npm install grunt-init@master -g
RUN git clone https://github.com/gruntjs/grunt-init-node.git /.grunt-init/node

# install node inspector for debugging
RUN npm install node-inspector -g
####################################################
# Create osc-webserver
FROM dspeed/osc-nodejs
RUN npm install -g harp
