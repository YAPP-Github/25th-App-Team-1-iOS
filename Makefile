
USER_NAME = $(shell python3 Scripts/author_name.py)
CURRENT_DATE = $(shell pipenv run python Scripts/current_date.py)


#Feature:
#	@mkdir -p Projects/Feature/${name};
#	@tuist scaffold Feature \
#	--name ${name} \
#	--author "$(USER_NAME)" \
#	--current-date "$(CURRENT_DATE)";
#	@rm Pipfile >/dev/null 2>&1;
#	@tuist edit

noapp ?= false

Feature:
ifeq ($(noapp), true)
	@mkdir -p Projects/Feature/${name};
	@tuist scaffold FeatureWithoutExample \
	--name ${name} \
	--author "$(USER_NAME)" \
	--current-date "$(CURRENT_DATE)";
else
	@mkdir -p Projects/Feature/${name};
	@tuist scaffold Feature \
	--name ${name} \
	--author "$(USER_NAME)" \
	--current-date "$(CURRENT_DATE)";
endif
	@rm Pipfile >/dev/null 2>&1;
	@tuist edit
