#!/bin/sh
#
# Oracle Endeca Tools Service
#
# chkconfig: 35 95 20
# description: Oracle Endeca Tools Service (Workbench)

ENDECA_USER=endeca
ENDECA_TOOLS_ROOT=/home/endeca/endeca/ToolsAndFrameworks/11.3.0

usage() {
  echo "Usage: ${0} (start|stop)"
  echo ""
  echo "  start   - starts Workbench as a background process"
  echo "  stop    - stops Workbench"
  echo ""
}

case "${1}" in
  start)
    /bin/su - "${ENDECA_USER}" -c "${ENDECA_TOOLS_ROOT}/server/bin/startup.sh"
    ;;
  stop)
    /bin/su - "${ENDECA_USER}" -c "${ENDECA_TOOLS_ROOT}/server/bin/shutdown.sh"
    ;;
  *)
    usage
    exit 2
esac

exit $?