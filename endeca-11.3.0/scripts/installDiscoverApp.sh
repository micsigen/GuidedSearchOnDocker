#!/bin/sh
#
# Install Discover App with some tweaks
#

INTERNAL_IP=127.0.0.1

# deploy app
/home/endeca/endeca/ToolsAndFrameworks/11.3.0/deployment_template/bin/deploy.sh --app /appl/endeca/ToolsAndFrameworks/11.3.0/reference/discover-data/deploy.xml

# change logging level to see everything
sed -i 's/\(INFO\|WARNING\|CONFIG\)/ALL/g' /home/endeca/endeca/apps/Discover/config/script/logging.properties


# change host to IP address
HOST=`head -1 /etc/hosts | cut -f2`
grep $HOST -rl . | xargs sed -i "s/$HOST/1$INTERNAL_IP/g"

#check if services are running

/appl/endeca/apps/Discover/control/initialize_services.sh
/appl/endeca/apps/Discover/control/load_baseline_test_data.sh
/appl/endeca/apps/Discover/control/baseline_update.sh
/appl/endeca/apps/Discover/control/promote_content.sh
