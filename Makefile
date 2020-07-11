.PHONY: help
SHELL := /bin/bash

PROJECT_ROOT = $(shell pwd)
PROJECT_NAME = stock_portifolio_api
DJANGO_CMD = cd $(PROJECT_NAME) && python manage.py
SETTINGS = $(PROJECT_NAME).settings

help:  ## This help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST) | sort

clean:  ## Clean python bytecodes, optimized files, logs, cache, coverage...
	@find . -name "*.pyc" | xargs rm -rf
	@find . -name "*.pyo" | xargs rm -rf
	@find . -name "__pycache__" -type d | xargs rm -rf
	@find . -name ".cache" -type d | xargs rm -rf
	@find . -name ".coverage" -type f | xargs rm -rf
	@find . -name ".pytest_cache" -type d | xargs rm -rf
	@rm -rf htmlcov/
	@rm -f coverage.xml
	@rm -f *.log
	@echo 'Temporary files deleted'

conf-env:  ## Generate the .env file for local development
	@cp -n contrib/localenv .env
	@echo 'Please configure params from .env file before starting. Ask for one from your peers (may be easier ;)'

migrations:  ## Create migrations
	$(DJANGO_CMD) makemigrations $(app)

migrate: ##  Execute the migrations
	@echo 'Migrating...'
	$(DJANGO_CMD) migrate

migrate-dev: ##  Execute the migrations on the development environment
	@set -a && source .env && set +a && $(DJANGO_CMD) migrate

requirements-pip:  ## Install the app requirements
	@pip install --upgrade pip
	@pip install -r requirements/pip.txt

requirements-apt:  ## Install ubuntu packages to provide the local development environment
	@echo 'IMPORTANT: sudo is required to install system dependencies from `linux.apt` file'
	@sudo apt-get install $(shell cat requirements/linux.apt | tr "\n" " ")

createsuperuser:  ## Create the django admin superuser
	$(DJANGO_CMD) createsuperuser

test: clean  ## Run the test suite without integration tests
	py.test $(PROJECT_NAME) --ds=$(SETTINGS) -s -vvv

test-matching: clean  ## Run only tests matching pattern. E.g.: make test-matching test=TestClassName
	py.test $(PROJECT_NAME)/ -k $(test) --ds=$(SETTINGS) -s -vvv

coverage: clean  ## Run the test coverage report
	@mkdir -p logs
	py.test --cov-config .coveragerc --cov $(PROJECT_NAME) $(PROJECT_NAME) --ds=$(SETTINGS) --cov-report term-missing

lint: clean  ## Run pylint linter
	@printf '\n --- \n >>> Running linter...<<<\n'
	@pylint --rcfile=.pylintrc  $(PROJECT_NAME)/*
	@printf '\n FINISHED! \n --- \n'

style:  ## Run isort and black auto formatting code style in the project
	@isort -m 3 -tc -y
	@black -S -t py37 -l 79 $(PROJECT_NAME)/. --exclude '/(\.git|\.venv|env|venv|build|dist)/'

style-check:  ## Check isort and black code style
	@black -S -t py37 -l 79 --check $(PROJECT_NAME)/. --exclude '/(\.git|\.venv|env|venv|build|dist)/'

shell: clean  ## Run a django shell
	$(DJANGO_CMD) shell_plus

runserver: clean migrate  ## Run production (gunicorn) web server
	@cd  $(PROJECT_NAME) && gunicorn --worker-tmp-dir /dev/shm --log-level INFO --workers=2 --threads=4 --worker-class=gthread --bind 0.0.0.0:8080  $(PROJECT_NAME).wsgi:application

runserver-dev-port: clean migrate-dev  ## Run development web server on a different port
	set -a && source .env && set +a && $(DJANGO_CMD) runserver 0.0.0.0:$$APP_PORT

runserver-dev: clean migrate-dev  ## Run development web server
	$(DJANGO_CMD) runserver 0.0.0.0:8080

manage: clean ## Run command from manage.py
	$(DJANGO_CMD) $(COMMAND)

show-urls: clean  ## Show all urls available on the app
	$(DJANGO_CMD) show_urls

