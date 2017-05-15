FROM micsigen/endeca:11.3.0
MAINTAINER Balazs Major <majorbalu@gmail.com>

USER root

ENV ENDECA_USER=endeca
ENV ENDECA_ROOT=/home/endeca/endeca/PlatformServices/11.3.0
ENV ENDECA_CONF=/home/endeca/endeca/PlatformServices/workspace
ENV CAS_ROOT=/home/endeca/endeca/CAS/11.3.0
ENV CAS_WORKSPACE=/home/endeca/endeca/CAS/workspace
ENV ENDECA_TOOLS_ROOT=/home/endeca/endeca/ToolsAndFrameworks/11.3.0

RUN cp /home/endeca/bin/workbench-init.d.sh /etc/init.d/workbench
RUN /sbin/chkconfig --add workbench

RUN cp /home/endeca/bin/cas-init.d.sh /etc/init.d/cas
RUN /sbin/chkconfig --add cas

RUN cp /home/endeca/bin/ps-init.d.sh /etc/init.d/ps
RUN /sbin/chkconfig --add ps

CMD ["/run.sh"]