#!/bin/sh
#
# Install Discover App with some tweaks
#

INTERNAL_IP=127.0.0.1

# deploy app
/home/endeca/endeca/ToolsAndFrameworks/11.3.0/deployment_template/bin/deploy.sh --app /home/endeca/endeca/ToolsAndFrameworks/11.3.0/reference/discover-data-cas/deploy.xml

/home/endeca/endeca/apps/Discover/control/initialize_services.sh
/home/endeca/endeca/apps/Discover/control/load_baseline_test_data.sh
/home/endeca/endeca/apps/Discover/control/baseline_update.sh
/home/endeca/endeca/apps/Discover/control/promote_content.sh
