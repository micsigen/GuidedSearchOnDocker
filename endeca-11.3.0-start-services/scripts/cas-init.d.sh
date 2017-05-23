#!/bin/sh
#
# Content Aquisition System
#
# chkconfig: 35 95 20
# description: Content Aquisition System

ENDECA_USER=endeca
CAS_ROOT=/home/endeca/endeca/CAS/11.3.0
export CAS_ROOT
CAS_WORKSPACE=/home/endeca/endeca/CAS/workspace
export CAS_WORKSPACE

usage() {
  echo "Usage: ${0} (start|stop)"
  echo ""
  echo "  start   - starts CAS as a background process"
  echo "  stop    - stops CAS"
  echo ""
}

case "${1}" in
  start)
    /bin/su $ENDECA_USER -c "$CAS_ROOT/bin/cas-service.sh &"
    ;;
  stop)
    /bin/su $ENDECA_USER -c "$CAS_ROOT/bin/cas-service-shutdown.sh &"
    ;;
  *)
    usage
    exit 2
esac

exit $?