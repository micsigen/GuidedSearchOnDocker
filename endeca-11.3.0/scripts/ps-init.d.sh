#!/bin/sh
#
# Platform Services
#
# chkconfig: 35 95 20
# description: Platform Services

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