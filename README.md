#Oracle Commerce Guided Search Environment Running On Docker

# Goals

A quick and repeatable install for development or testing purposes that can be quickly stood up using docker-compose.

# Docker

Docker is....  A container, not a VM

# Components

For those with access the Oracle files can be downloaded from https://edelivery.oracle.com.  

## Oracle Commerce Guided Search

Dockerfiles are provided for 11.3.

You will need to provide the Guided Search install files.  

* The Oracle Commerce Guided Search version being installed in from media pack 11.3:
 * Oracle Commerce MDEX Engine 11.3 for Linux
 * Oracle Commerce Guided Search Platform Services 11.3 for Linux
 * Oracle Commerce Experience Manager Tools and Frameworks 11.3 for Linux
 * Oracle Commerce Content Acquisition System 11.3 for Linux

* The files needed for the 11.3 install are
 * V861206-01.zip
 * V861203-01.zip
 * V861200-01.zip
 * V861198-01.zip
 
By default the Endeca install is under /home/endeca/endeca/ and the default user is the endeca.  

Copy the necessary Oracle supplied zip files to the /tools folder.

# Base image

This Docker image contains full install of Oracle Commerce Guided Search ecosystems into the home of endeca user (/home/endeca/). The entry point of image is staring of SSH Deamon similar of the base Docker image. (See the CentOS image - https://hub.docker.com/r/tutum/centos/)

Run the build-endeca-11.3.0.sh shell script:

```
docker run -d -p 2222:22  -p 8006:8006 -p 8888:8888 -p 15000:15000 -p 15002:15002 -p 15010:15010 --name endeca-11.3.0 micsigen/endeca:11.3.0
```

# Extended image - start services

This Docker image is based of abouve mentioned endeca-11.3.0 image. After the base image created copy the service start script into the /etc/init.d folder and start in the background. If you need to run the services in the background you need to run the build-endeca-11.3.0.sh shell script.

```
docker run -d -p 2222:22  -p 8006:8006 -p 8888:8888 -p 15000:15000 -p 15002:15002 -p 15010:15010 --name endeca-11.3.0-start-services micsigen/endeca-start-services:11.3.0
```

# Install Discover App in Endeca

By default the build script installs the reference app

/home/endeca/endeca/apps/Discover/config/ifcr/configuration/tools/preview.json
/home/endeca/endeca/Discover/config/script/WorkbenchConfig.xml
/home/endeca/endeca/Discover/config/script/DataIngest.xml
/home/endeca/endeca/Discover/config/script/LiveDgraphCluster.xml
/home/endeca/endeca/Discover/config/script/ReportGeneration.xml
/home/endeca/endeca/Discover/config/script/AuthoringDgraphCluster.xml
/home/endeca/endeca/Discover/config/script/AppConfig.xml
/home/endeca/endeca/Discover/config/editors_config/editors.xml
/home/endeca/endeca/Discover/config/editors_config/services/dataservice.json
/home/endeca/endeca/Discover/config/editors_config/services/endecaBrowserService.json
/home/endeca/endeca/Discover/control/set_templates.sh
/home/endeca/endeca/Discover/control/get_templates.sh


