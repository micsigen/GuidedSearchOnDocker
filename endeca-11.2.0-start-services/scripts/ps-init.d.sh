#!/bin/sh
#
# Platform Services
#
# chkconfig: 35 95 20
# description: Platform Services

ENDECA_USER=endeca
ENDECA_ROOT="/home/endeca/endeca/PlatformServices/11.3.0"
export ENDECA_ROOT
ENDECA_CONF="/home/endeca/endeca/PlatformServices/workspace"
export ENDECA_CONF

usage() {
  echo "Usage: ${0} (start|stop)"
  echo ""
  echo "  start   - starts Platform Services as a background process"
  echo "  stop    - stops Platform Services"
  echo ""
}

case "${1}" in
  start)
    /bin/su $ENDECA_USER -c "$ENDECA_ROOT/tools/server/bin/startup.sh"
    ;;
  stop)
    /bin/su $ENDECA_USER -c "$ENDECA_ROOT/tools/server/bin/shutdown.sh"
    ;;
  *)
    usage
    exit 2
esac

exit $?