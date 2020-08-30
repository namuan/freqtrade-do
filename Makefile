export PROJECTNAME=$(shell basename "$(PWD)")
export REMOTEDIR=${PROJECTNAME}-v1

.SILENT: ;               # no need for @

venv: ## Sets up venv
	python3 -m venv venv

requirements: ## Sets up required dependencies
	./venv/bin/pip install -r web-infra/requirements.txt
	./venv/bin/ansible-galaxy --version
	./venv/bin/ansible-playbook --version

bootstrap: ## Sets up required directory
	rsync -avzr web-infra/bootstrap.sh root-${PROJECTNAME}:./bootstrap.sh
	ssh root-${PROJECTNAME} -C "/bin/bash ./bootstrap.sh"


doplaybook: ## Start Droplet
	./venv/bin/ansible-galaxy install -r web-infra/requirements.yml
	./venv/bin/ansible-playbook -i web-infra/ansible/hosts web-infra/ansible/digitalocean_playbook.yml -l do

clean: ## Cleans all cached files
	find . -type d -name '__pycache__' | xargs rm -rf

deployapp: clean ## Deploy application
	ssh ${PROJECTNAME} -C "mkdir -vp ./${REMOTEDIR}"
	rsync -avzr \
        		./user_data/strategies \
        		${PROJECTNAME}:./${REMOTEDIR}/user_data
	rsync -avzr \
    		./config.json \
    		./scripts \
    		${PROJECTNAME}:./${REMOTEDIR}/

ssh: ## ssh into project server
	ssh ${PROJECTNAME}

setupfqlocal: ## Setup locally
	./scripts/freqtrade-install.sh

updatefqlocal: ## Setup locally
	./scripts/freqtrade-update.sh

source: ## Command to source env
	echo "deactivate; source ./freqtrade/.env/bin/activate"

setupfq: deployapp ## Start installation
	ssh ${PROJECTNAME} -C 'bash -l -c "cd ${REMOTEDIR};./scripts/freqtrade-install.sh"'

updatefq: deployapp ## Start installation
	ssh ${PROJECTNAME} -C 'bash -l -c "cd ${REMOTEDIR};./scripts/freqtrade-update.sh"'

runbot: deployapp ## Run bot
	ssh ${PROJECTNAME} -C 'bash -l -c "cd ${REMOTEDIR};./scripts/setup-freqtrade-bot.sh"'

setupplaybook: ## Setup Infrastructure on DigitalOcean
	./venv/bin/ansible-playbook web-infra/ansible/setup_playbook.yml -i web-infra/ansible/hosts -l doremote

deleteinfra: ## Deletes DigitalOcean Droplet
	doctl compute droplet delete ${PROJECTNAME}

.PHONY: help
.DEFAULT_GOAL := help

help: Makefile
	echo
	echo " Choose a command run in "$(PROJECTNAME)":"
	echo
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	echo
