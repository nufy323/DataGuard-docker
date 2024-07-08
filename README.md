# docker-dataguard

Files for building an Oracle Data Guard database in Docker

Currently working for version 12.2.

## Setup

Set Docker's memory limit to at least 8G

## Prerequisites
This repo is built on the Oracle Docker repository: https://github.com/oracle/docker-images

Download the following files from Oracle OTN:
```
LINUX.X64_193000_db_home.zip
```

## Set the environment
The ORADATA_VOLUME is for persisting data for the databases. Each database will inhabit a subdirectory of ORADATA_VOLUME based on the database unique name. DG_DIR is the base directory for this repo.
```
export COMPOSE_YAML=docker-compose.yml
export DB_VERSION=12.2.0
export IMAGE_NAME=oracle/database:${DB_VERSION}-ee
export ORADATA_VOLUME=~/oradata
export DG_DIR=/root/DataGuard-docker
```

## Run the build to create the oracle/datbase:19.3.0-ee Docker image
`./buildDockerImage.sh -v 12.2.0 -e`

## crate valume dir
make prepare_dir

## Run compose (detached)
`make docker_up`

## 

## Tail the logs
`docker-compose logs -f`

# Testing
The build has been tested by starting the databases under docker-compose and running DGMGRL validations and switchover through a variety of scenarios. It correctly resumes the configuration across stops/starts of docker-compose.

Please report any issues to oracle.sean@gmail.com. Thanks!

# CUSTOM CONFIGURATION
## Database configurations
Customize a configuration file for setting up the contaner hosts using the following format if the existing config_dataguard.lst does not meet your needs. This file is used for automated setup of the environment.

The pluggable database is ${ORACLE_SID}PDB1. The default configuration is:

```
cat << EOF > $DG_DIR/config_dataguard.lst
# Host | ID | Role    | DG Cfg | SID  | DB_UNQNAME | DG_TARGET | ORACLE_PWD
DG11   | 1  | PRIMARY | DG1    | DG11 | DG11       | DG21      | oracle
DG21   | 2  | STANDBY | DG1    | DG11 | DG21       | DG11      | oracle
EOF
```