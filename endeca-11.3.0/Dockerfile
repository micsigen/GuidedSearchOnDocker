FROM tutum/centos:centos7
MAINTAINER Balazs Major <majorbalu@gmail.com>

#######################################
# install necessary OS packages
RUN yum -y install which && \
    yum -y install libaio && \
    yum -y install glibc.i686 && \
    yum -y install sudo && \
    yum -y install tar && \
    yum -y install unzip.x86_64

#######################################
# environment variables

# environment variable for local location
ENV LOCAL_SCRIPTS scripts
ENV LOCAL_TOOLS tools

# environment variables for installables
ENV BASE_TMP_INSTALL /tmp
ENV BASE_TMP_ENDECA_INSTALL $BASE_TMP_INSTALL/endeca
ENV BASE_TMP_PACKAGE_INSTALL $BASE_TMP_ENDECA_INSTALL/packages
ENV SCRIPT_DIR $BASE_TMP_ENDECA_INSTALL/bin

# environment variables for endeca location
ENV USER_HOME_DIR /home/endeca
ENV BASE_ENDECA_DIR $USER_HOME_DIR/endeca

# platform services silent install specific env variables
ENV ENDECA_HTTP_SERVICE_PORT 8888
ENV ENDECA_HTTP_SERVICE_SHUTDOWN_PORT 8090
ENV ENDECA_MDEX_INSTALL_DIR $BASE_ENDECA_DIR/MDEX/11.3.0

# CAS silent install specific env variables
ENV CAS_PORT 8500
ENV CAS_SHUTDOWN_PORT 8506
ENV CAS_HOST localhost

ENV WORKBENCH_PORT 8006

RUN useradd -m -d /home/endeca endeca -G root -p endeca

#######################################
# create directories for copying initial endeca packages
RUN mkdir -p $BASE_TMP_PACKAGE_INSTALL && \
    chmod -R 777 $BASE_TMP_ENDECA_INSTALL

# directory for final install of endeca created as part of script directory
RUN mkdir -p $SCRIPT_DIR

#######################################
# Copy script that creates unique password for root and other scripts
ADD $LOCAL_SCRIPTS/*.sh $SCRIPT_DIR/
RUN chmod -R 755 $SCRIPT_DIR && \
    chmod +x $SCRIPT_DIR/*.sh

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

RUN chown -R endeca $BASE_TMP_ENDECA_INSTALL

USER endeca
#######################################
# Unzip all packages to get install scripts and files
RUN unzip $BASE_TMP_PACKAGE_INSTALL/V861206-01.zip -d $BASE_TMP_ENDECA_INSTALL && \
    unzip $BASE_TMP_PACKAGE_INSTALL/V861203-01.zip -d $BASE_TMP_ENDECA_INSTALL && \
    unzip $BASE_TMP_PACKAGE_INSTALL/V861200-01.zip -d $BASE_TMP_ENDECA_INSTALL && \
    unzip $BASE_TMP_PACKAGE_INSTALL/V861198-01.zip -d $BASE_TMP_ENDECA_INSTALL

RUN chmod +x $BASE_TMP_ENDECA_INSTALL/*.bin

#######################################
# MDEX INSTALLATION FOLLOWS
RUN echo USER_INSTALL_DIR=$USER_HOME_DIR > $BASE_TMP_ENDECA_INSTALL/mdex_response.properties

RUN $BASE_TMP_ENDECA_INSTALL/OCmdex11.3.0-Linux64_1186050.bin -i silent -f mdex_response.properties

# copy mdex environment variables to .bashrc
RUN cat $ENDECA_MDEX_INSTALL_DIR/mdex_setup_sh.ini >> $USER_HOME_DIR/.bashrc
RUN source $USER_HOME_DIR/.bashrc

# set mdex environment variables for rest of install
ENV ENDECA_MDEX_ROOT $BASE_ENDECA_DIR/MDEX/11.3.0
ENV PATH $ENDECA_MDEX_ROOT/bin:$PATH

#######################################
# PLATFORM INSTALLATION FOLLOWS

#create silent install text file
ENV PS_SILENT_PATH $BASE_TMP_ENDECA_INSTALL/ps_response.properties
RUN echo INSTALLDIR=$BASE_ENDECA_DIR/PlatformServices > $PS_SILENT_PATH && \
    echo ETOOLS_HTTP_PORT=$ENDECA_HTTP_SERVICE_PORT >> $PS_SILENT_PATH && \
    echo ETOOLS_SERVER_PORT=$ENDECA_HTTP_SERVICE_SHUTDOWN_PORT >> $PS_SILENT_PATH && \
    echo EAC_MDEX_ROOT=$ENDECA_MDEX_INSTALL_DIR >> $PS_SILENT_PATH

# install platform services
RUN $BASE_TMP_ENDECA_INSTALL/OCplatformservices11.3.0-Linux64.bin -i silent -f ps_response.properties

# RUN ln -s $USER_HOME_DIR/endeca/PlatformServices/ $BASE_ENDECA_DIR/PlatformServices
RUN cat $BASE_ENDECA_DIR/PlatformServices/workspace/setup/installer_sh.ini >> $USER_HOME_DIR/.bashrc
RUN source $USER_HOME_DIR/.bashrc

# set platform services variables for rest of install
ENV VERSION 11.3.0
ENV BUILD_VERSION 11.3.0
ENV ARCH_OS Linux64
ENV PRODUCT IAP
ENV ENDECA_INSTALL_BASE $BASE_DIR
ENV ENDECA_ROOT $BASE_ENDECA_DIR/PlatformServices/11.3.0
ENV PERLLIB $ENDECA_ROOT/lib/perl:$ENDECA_ROOT/lib/perl/Control:$ENDECA_ROOT/perl/lib:$ENDECA_ROOT/perl/lib/site_perl:$PERLLIB
ENV PERL5LIB $ENDECA_ROOT/lib/perl:$ENDECA_ROOT/lib/perl/Control:$ENDECA_ROOT/perl/lib:$ENDECA_ROOT/perl/lib/site_perl:$PERL5LIB
ENV PATH $ENDECA_ROOT/bin:$ENDECA_ROOT/perl/bin:$ENDECA_ROOT/utilities:$PATH
ENV ENDECA_CONF $BASE_ENDECA_DIR/PlatformServices/workspace

#######################################
# TOOLS AND FRAMEWORKS INSTALLATION FOLLOWS
# set tools and frameworks variables for rest of install
ENV ENDECA_TOOLS_ROOT $BASE_ENDECA_DIR/ToolsAndFrameworks/11.3.0
ENV ENDECA_TOOLS_CONF $BASE_ENDECA_DIR/ToolsAndFrameworks/11.3.0/server/workspace
ENV TF_SILENT_SH_PATH $BASE_TMP_ENDECA_INSTALL/cd/Disk1/install/silent_install.sh
ENV TF_SILENT_RESP_PATH $BASE_TMP_ENDECA_INSTALL/cd/Disk1/install/silent_response.rsp

RUN sed -i 's/dba/root/g' $TF_SILENT_RESP_PATH
RUN $TF_SILENT_SH_PATH $TF_SILENT_RESP_PATH ToolsAndFrameworks $BASE_ENDECA_DIR/ToolsAndFrameworks

RUN echo ENDECA_TOOLS_ROOT=$ENDECA_TOOLS_ROOT >> $USER_HOME_DIR/.bashrc
RUN echo ENDECA_TOOLS_CONF=$ENDECA_TOOLS_CONF >> $USER_HOME_DIR/.bashrc
RUN source $USER_HOME_DIR/.bashrc

USER root
RUN /home/endeca/oraInventory/orainstRoot.sh

#######################################
# CAS INSTALLATION FOLLOWS

#create silent install text file
USER endeca
RUN echo INSTALLDIR=$BASE_ENDECA_DIR/CAS/11.3.0 > $BASE_TMP_ENDECA_INSTALL/cas-silent.txt && \
    echo CASPORT=$CAS_PORT >> $BASE_TMP_ENDECA_INSTALL/cas-silent.txt && \    
    echo CASSHUTDOWNPORT=$CAS_SHUTDOWN_PORT >> $BASE_TMP_ENDECA_INSTALL/cas-silent.txt && \
    echo CASHOST=$CAS_HOST >> $BASE_TMP_ENDECA_INSTALL/cas-silent.txt && \
    echo ENDECA_TOOLS_ROOT=$ENDECA_TOOLS_ROOT >> $BASE_TMP_ENDECA_INSTALL/cas-silent.txt && \
    echo ENDECA_TOOLS_CONF=$ENDECA_TOOLS_CONF >> $BASE_TMP_ENDECA_INSTALL/cas-silent.txt

#install CAS
RUN $BASE_TMP_ENDECA_INSTALL/OCcas11.3.0-Linux64.bin -i silent -f cas-silent.txt

RUN echo CAS_ROOT=$BASE_ENDECA_DIR/CAS/11.3.0
RUN echo CAS_WORKSPACE=$BASE_ENDECA_DIR/CAS/workspace
RUN source $USER_HOME_DIR/.bashrc >> $USER_HOME_DIR/.bashrc

#######################################
# create apps directory
RUN mkdir $BASE_ENDECA_DIR/apps
RUN mkdir $USER_HOME_DIR/bin
RUN mkdir $USER_HOME_DIR/conf

RUN mv $SCRIPT_DIR/*.sh $USER_HOME_DIR/bin
RUN sed -i 's/-DSTOP.PORT=/-DSTOP.PORT=8506/g' $BASE_ENDECA_DIR/CAS/11.3.0/bin/cas-service.sh

RUN cp $BASE_TMP_ENDECA_INSTALL/cas-silent.txt $USER_HOME_DIR/conf/ && \
    cp $BASE_TMP_ENDECA_INSTALL/cd/Disk1/install/silent_response.rsp $USER_HOME_DIR/conf/ && \
    cp $PS_SILENT_PATH $USER_HOME_DIR/conf/

USER root

#######################################
# install is done start cleanup to remove initial packages
RUN rm -rf $BASE_TMP_ENDECA_INSTALL
RUN rm -rf $BASE_TMP_PACKAGE_INSTALL

ENV AUTHORIZED_KEYS **None**

VOLUME ["/home/endeca/endeca/apps"]
EXPOSE 22 $CAS_PORT $WORKBENCH_PORT
CMD ["/run.sh"]