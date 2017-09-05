#!/bin/sh
#
# Install Discover App with some tweaks
#

INTERNAL_IP=127.0.0.1

# deploy app
/home/endeca/endeca/ToolsAndFrameworks/11.3.0/deployment_template/bin/deploy.sh \
	--app /home/endeca/deploy/ATGWebshop/deploy.xml \
	--install-config /home/endeca/deploy/ATGWebshop/deploy_prompt.xml --no-prompt

/home/endeca/endeca/apps/ATGWebshop/control/initialize_services.sh
/home/endeca/endeca/apps/ATGWebshop/control/load_baseline_test_data.sh
/home/endeca/endeca/apps/ATGWebshop/control/baseline_update.sh
/home/endeca/endeca/apps/ATGWebshop/control/promote_content.sh
