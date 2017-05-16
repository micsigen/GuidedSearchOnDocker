FROM micsigen/endeca:11.3.0
MAINTAINER Balazs Major <majorbalu@gmail.com>

USER root

ENV LOCAL_SCRIPTS scripts
ENV SCRIPT_DIR /home/endeca/bin

ADD $LOCAL_SCRIPTS/*.sh $SCRIPT_DIR/

RUN chmod -R 755 $SCRIPT_DIR && \
    chmod +x $SCRIPT_DIR/*.sh

RUN cp /home/endeca/bin/ps-init.d.sh /etc/init.d/ps
RUN /sbin/chkconfig --add ps

RUN cp /home/endeca/bin/cas-init.d.sh /etc/init.d/cas
RUN /sbin/chkconfig --add cas

RUN cp /home/endeca/bin/workbench-init.d.sh /etc/init.d/workbench
RUN /sbin/chkconfig --add workbench

RUN mv /home/endeca/bin/start-services.sh /

CMD ["/start-services.sh"]