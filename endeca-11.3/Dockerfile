FROM tutum/centos:centos7
MAINTAINER Balazs Major <majorbalu@gmail.com>

#######################################
# install necessary OS packages
RUN yum -y install which && \
    yum -y install libaio && \
    yum -y install glibc.i686 && \
    yum -y install sudo && \
    yum -y install tar && \
    yum -y install unzip.x86_64 && \
    yum -y install gawk

#######################################
# environment variables

# user information
ENV USER endeca
ENV USER_HOME_DIR /home/$USER

# environment variable for local location
ENV LOCAL_SCRIPTS scripts
ENV LOCAL_TOOLS tools

# environment variables for installables
ENV BASE_TMP_INSTALL /tmp
ENV BASE_TMP_ENDECA_INSTALL $BASE_TMP_INSTALL/endeca
ENV BASE_TMP_PACKAGE_INSTALL $BASE_TMP_ENDECA_INSTALL/packages
ENV SCRIPT_DIR $BASE_TMP_ENDECA_INSTALL/bin

# environment variables for endeca location
ENV BASE_ENDECA_DIR $USER_HOME_DIR/endeca

# platform services silent install specific env variables
ENV ENDECA_HTTP_SERVICE_PORT 8888
ENV ENDECA_HTTP_SERVICE_SHUTDOWN_PORT 8090
ENV ENDECA_CONTROL_SYSTEM_JCD_PORT 8088
ENV RUN_EAC_CONTROLLER Y
ENV ENDECA_MDEX_INSTALL_DIR $BASE_ENDECA_DIR/MDEX/11.3
ENV INSTALL_REF_APPS Y

# CAS silent install specific env variables
ENV CAS_PORT 8500
ENV CAS_SHUTDOWN_PORT 8506
ENV CAS_HOST localhost

#######################################
# create directories for copying initial endeca packages
RUN mkdir -p $BASE_TMP_PACKAGE_INSTALL && \
    chmod -R 777 $BASE_TMP_ENDECA_INSTALL

# directory for final install of endeca created as part of script directory
RUN mkdir -p $SCRIPT_DIR
RUN chmod -R 755 $SCRIPT_DIR

#######################################
# Copy script that creates unique password for root and other scripts
ADD $LOCAL_SCRIPTS/modsudoers.sh $SCRIPT_DIR/
ADD $LOCAL_SCRIPTS/setup*.sh $SCRIPT_DIR/
ADD $LOCAL_SCRIPTS/start.sh $SCRIPT_DIR/
ADD $LOCAL_SCRIPTS/shutdown.sh $SCRIPT_DIR/
ADD $LOCAL_SCRIPTS/captureEndecaLogs.sh $SCRIPT_DIR/
ADD $LOCAL_SCRIPTS/installDiscoverApp.sh $SCRIPT_DIR/

#######################################
# Set properties for scripts to be executable
RUN chmod +x $SCRIPT_DIR/*.sh

#######################################
#Run commands to create endeca user and modify sudoers
RUN $SCRIPT_DIR/setup.sh

#######################################
# start copying across all endeca packages
#
#OCmdex11.3.0-Linux64_1186050.bin
#OCpresAPI11.3.0-Linux64_1186050.tgz
ADD $LOCAL_TOOLS/V861206-01.zip $BASE_TMP_PACKAGE_INSTALL/V861206-01.zip

#OCplatformservices11.3.0-Linux64.bin
ADD $LOCAL_TOOLS/V861203-01.zip $BASE_TMP_PACKAGE_INSTALL/V861203-01.zip

#ToolsAndFrameworks
ADD $LOCAL_TOOLS/V861200-01.zip $BASE_TMP_PACKAGE_INSTALL/V861200-01.zip

#OCcas11.3.0-Linux64.bin
ADD $LOCAL_TOOLS/V861198-01.zip $BASE_TMP_PACKAGE_INSTALL/V861198-01.zip

#######################################
# Unzip all packages to get install scripts and files
RUN unzip $BASE_TMP_PACKAGE_INSTALL/V861206-01.zip -d $BASE_TMP_ENDECA_INSTALL && \
    unzip $BASE_TMP_PACKAGE_INSTALL/V861203-01.zip -d $BASE_TMP_ENDECA_INSTALL && \
    unzip $BASE_TMP_PACKAGE_INSTALL/V861200-01.zip -d $BASE_TMP_ENDECA_INSTALL && \
    unzip $BASE_TMP_PACKAGE_INSTALL/V861198-01.zip -d $BASE_TMP_ENDECA_INSTALL

# set permissions of scripts to run
RUN chmod +x $BASE_TMP_INSTALL/**/*.sh

#######################################
# MDEX INSTALLATION FOLLOWS
RUN echo USER_INSTALL_DIR=$ENDECA_MDEX_INSTALL_DIR > $BASE_TMP_ENDECA_INSTALL/mdex_response.properties
RUN $BASE_TMP_ENDECA_INSTALL/OCmdex11.3.0-Linux64_1186050.bin -i silent -f mdex_response.properties

# copy mdex environment variables to .bashrc
RUN /setup2.sh

# set mdex environment variables for rest of install
ENV ENDECA_MDEX_ROOT $BASE_ENDECA_DIR/MDEX/11.3
ENV PATH $ENDECA_MDEX_ROOT/bin:$PATH

#######################################
# PLATFORM INSTALLATION FOLLOWS

#create silent install text file
RUN echo $ENDECA_HTTP_SERVICE_PORT > $BASE_TMP_ENDECA_INSTALL/platformservices-silent.txt && \
    echo $ENDECA_HTTP_SERVICE_SHUTDOWN_PORT >> $BASE_TMP_ENDECA_INSTALL/platformservices-silent.txt && \
    echo $ENDECA_CONTROL_SYSTEM_JCD_PORT >> $BASE_TMP_ENDECA_INSTALL/platformservices-silent.txt && \
    echo $RUN_EAC_CONTROLLER >> $BASE_TMP_ENDECA_INSTALL/platformservices-silent.txt && \
    echo $ENDECA_MDEX_INSTALL_DIR >> $BASE_TMP_ENDECA_INSTALL/platformservices-silent.txt && \
    echo $INSTALL_REF_APPS >> $BASE_TMP_ENDECA_INSTALL/platformservices-silent.txt

# install platform services
RUN $BASE_TMP_ENDECA_INSTALL/platformservices_614734339_x86_64pc-linux.sh --silent --target $BASE_DIR < $BASE_TMP_ENDECA_INSTALL/platformservices-silent.txt

RUN cat $BASE_ENDECA_DIR/PlatformServices/workspace/setup/installer_sh.ini >> $USER_HOME_DIR/.bashrc
RUN source $USER_HOME_DIR/.bashrc

#RUN SETUP

# set platform services variables for rest of install
ENV VERSION 6.1.4
ENV BUILD_VERSION 6.1.4.734339
ENV ARCH_OS x86_64pc-linux
ENV PRODUCT IAP
ENV ENDECA_INSTALL_BASE $BASE_DIR
ENV ENDECA_ROOT $BASE_ENDECA_DIR/PlatformServices/6.1.4
ENV PERLLIB $ENDECA_ROOT/lib/perl:$ENDECA_ROOT/lib/perl/Control:$ENDECA_ROOT/perl/lib:$ENDECA_ROOT/perl/lib/site_perl:$PERLLIB
ENV PERL5LIB $ENDECA_ROOT/lib/perl:$ENDECA_ROOT/lib/perl/Control:$ENDECA_ROOT/perl/lib:$ENDECA_ROOT/perl/lib/site_perl:$PERL5LIB
ENV PATH $ENDECA_ROOT/bin:$ENDECA_ROOT/perl/bin:$ENDECA_ROOT/utilities:$PATH
ENV ENDECA_CONF $BASE_ENDECA_DIR/PlatformServices/workspace

#  ENDECA_REFERENCE_DIR points to the directory the reference implementations
#  are installed in.  It is not required to run any Endeca software.
ENV ENDECA_REFERENCE_DIR $BASE_ENDECA_DIR/PlatformServices/reference

#######################################
# TOOLS AND FRAMEWORKS INSTALLATION FOLLOWS
RUN unzip $BASE_TMP_PACKAGE_INSTALL/V37716-01.zip -d $BASE_ENDECA_DIR

# set tools and frameworks variables for rest of install
ENV ENDECA_TOOLS_ROOT $BASE_ENDECA_DIR/ToolsAndFrameworks/3.1.2/
ENV ENDECA_TOOLS_CONF $BASE_ENDECA_DIR/ToolsAndFrameworks/3.1.2/server/workspace

RUN echo 'ENDECA_TOOLS_ROOT=$BASE_ENDECA_DIR/ToolsAndFrameworks/3.1.2/' >> $USER_HOME_DIR/.bashrc
RUN echo 'ENDECA_TOOLS_CONF=$BASE_ENDECA_DIR/ToolsAndFrameworks/3.1.2/server/workspace' >> $USER_HOME_DIR/.bashrc
RUN source $USER_HOME_DIR/.bashrc

#######################################
# CAS INSTALLATION FOLLOWS

#create silent install text file
RUN echo $CAS_PORT > $BASE_TMP_ENDECA_INSTALL/cas-silent.txt && \
    echo $CAS_SHUTDOWN_PORT >> $BASE_TMP_ENDECA_INSTALL/cas-silent.txt && \
    echo $CAS_HOST >> $BASE_TMP_ENDECA_INSTALL/cas-silent.txt

#install CAS
RUN $BASE_TMP_ENDECA_INSTALL/cas-3.1.2.1-x86_64pc-linux.RC2.sh --silent --target $BASE_DIR < $BASE_TMP_ENDECA_INSTALL/cas-silent.txt

#######################################
#
# TODO TODO TODO TODO
#
# install relevancy evaluator
#RUN mv /tmp/endeca/Endeca/Solutions $BASE_ENDECA_DIR

#RUN cp $BASE_ENDECA_DIR/ToolsAndFrameworks/3.1.1/assembler/lib/endeca_navigation-6.4.0.jar $BASE_ENDECA_DIR/Solutions/relrankEvaluator-2.1.2/relrankEvaluator/WEB-INF/lib/endeca_navigation.jar

# write context into relrankEvaluator.xml file
#RUN /setup5.sh

# place correct extensions file
#ADD tools/ws-extensions.xml $BASE_ENDECA_DIR/ToolsAndFrameworks/3.1.1/server/workspace/conf/ws-extensions.xml

# place correct menu items
#ADD tools/ws-mainMenu.xml $BASE_ENDECA_DIR/ToolsAndFrameworks/3.1.1/server/workspace/conf/ws-mainMenu.xml

#######################################
# create apps directory
RUN mkdir $BASE_ENDECA_DIR/apps

#######################################
# set user and permissions to endeca
RUN chown -R endeca.endeca $BASE_ENDECA_DIR/
RUN chmod -R 755 $BASE_ENDECA_DIR/

#######################################
# install is done start cleanup to remove initial packages
RUN rm -rf $BASE_TMP_ENDECA_INSTALL
RUN rm /setup*.sh

ENV AUTHORIZED_KEYS **None**

EXPOSE 22
CMD ["/run.sh"]