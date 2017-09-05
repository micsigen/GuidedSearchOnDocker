#!/bin/sh

ENDECA_LOCAL_ROOT="/home/endeca/home"
$ENDECA_LOCAL_ROOT/PlatformServices/11.2.0/tools/server/bin/shutdown.sh
$ENDECA_LOCAL_ROOT/CAS/11.2.0/bin/cas-service-shutdown.sh
$ENDECA_LOCAL_ROOT/ToolsAndFrameworks/11.2.0/server/bin/shutdown.sh