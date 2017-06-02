#!/bin/bash

# Script to set up a Django project on Vagrant.
# Seed from: https://github.com/excellalabs/khanaas-django/blob/master/Vagrantfile

#----------------------------------------
# Installation Settings
#----------------------------------------
PROJECT_NAME=$1

PROJECT_DIR=/vagrant/
VIRTUALENV_DIR=/home/ubuntu/.virtualenvs/$PROJECT_NAME

PGSQL_VERSION=9.4

#----------------------------------------
# Reset, guarantee idempotency of vagrant provisioning?
#----------------------------------------
rm ~/.bash_profile



#----------------------------------------
# Pip
#----------------------------------------
# Update apt-get
apt-get update -y
# Install and update pip
apt-get install -y python3-pip
pip3 install --upgrade pip



#----------------------------------------
# Pip dependency (Global)
#----------------------------------------
# Pip virtual envs
pip3 install virtualenv virtualenvwrapper

# Python dev packages
#apt-get install -y virtualenv python3-pip
#apt-get install -y build-essential python python-dev python-pip python-virtualenv



#----------------------------------------
# Pip virtual environment setup and activation
#----------------------------------------
# Invoke, and make shell remember to invoke, virtualenvwrapper.sh
export WORKON_HOME=/home/ubuntu/.virtualenvs
echo "export WORKON_HOME=/home/ubuntu/.virtualenvs" >> /home/ubuntu/.bash_profile
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
echo "export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3" >> /home/ubuntu/.bash_profile
source /usr/local/bin/virtualenvwrapper.sh
echo "source /usr/local/bin/virtualenvwrapper.sh" >> /home/ubuntu/.bash_profile
# Setup Virtualenv Once
mkvirtualenv --python python3 $PROJECT_NAME
# Switch, and make shell remember to switch, virtual environment
echo "workon $PROJECT_NAME" >> /home/ubuntu/.bash_profile
workon $PROJECT_NAME


#----------------------------------------
# Pip virtual environment setup
#----------------------------------------
# Invoke, and make shell remember to invoke, virtualenvwrapper.sh
pip3 install


#----------------------------------------
# Postgresql
#----------------------------------------
if ! command -v psql; then
    # Include repo
    echo "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main" > /etc/apt/sources.list.d/pdgd.list
    # Add repo key
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add
    # Refresh apt cache
    apt-get update -y
    # Install PostgreSQL
    apt-get install -y postgresql-$PGSQL_VERSION
#    libpq-dev
#    cp /vagrant/provision/pg_hba.conf /etc/postgresql/$PGSQL_VERSION/main/
#    /etc/init.d/postgresql reload
fi




# ---

# Create postgresql user and database
#su -l postgres -c 'createuser --no-password -s -e khan'
#createdb -Ukhan $PROJECT_NAME




#su - vagrant -c "/usr/bin/virtualenv $VIRTUALENV_DIR && \
#    echo $PROJECT_DIR > $VIRTUALENV_DIR/.project && \
#    $VIRTUALENV_DIR/bin/pip install -r $PROJECT_DIR/requirements.txt"


#----------------------------------------
# SSH pre-hooks for convenience
#----------------------------------------
echo "cd $PROJECT_DIR" > /home/ubuntu/.bash_profile