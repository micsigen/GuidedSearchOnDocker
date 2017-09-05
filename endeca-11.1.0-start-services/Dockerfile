FROM micsigen/endeca:11.3.0
MAINTAINER Balazs Major <majorbalu@gmail.com>

USER root

RUN yum -y install dos2unix

ENV LOCAL_SCRIPTS scripts
ENV LOCAL_CONF conf
ENV SCRIPT_DIR /home/endeca/bin
ENV CONF_DIR /home/endeca/conf

ADD $LOCAL_SCRIPTS/*.sh $SCRIPT_DIR/
ADD $LOCAL_CONF/*.* $CONF_DIR/

RUN chmod -R 755 $SCRIPT_DIR && \
    chmod +x $SCRIPT_DIR/*.sh && \
    chmod -R 755 $CONF_DIR

RUN mv /home/endeca/bin/ps-init.d.sh /etc/init.d/ps
RUN /sbin/chkconfig --add ps

RUN mv /home/endeca/bin/cas-init.d.sh /etc/init.d/cas
RUN /sbin/chkconfig --add cas

RUN mv /home/endeca/bin/workbench-init.d.sh /etc/init.d/workbench
RUN /sbin/chkconfig --add workbench

USER endeca

RUN cd /home/endeca/endeca/ToolsAndFrameworks/11.3.0/credential_store/bin/ && \
	cat $CONF_DIR/password.txt | ./manage_credentials.sh add --key ifcr

USER root

RUN mv /home/endeca/bin/start-services.sh /
CMD ["/start-services.sh"]