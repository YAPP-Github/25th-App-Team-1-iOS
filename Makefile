
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
	
NOAPP_FLAG := $(filter -noapp,$(MAKEFLAGS))
	
Feature:
ifeq ($(NOAPP_FLAG), -noapp)
	@echo "feature project without example app"
	@mkdir -p Projects/Feature/${name};
	@tuist scaffold Feature \
	--name ${name} \
	--author "$(USER_NAME)" \
	--current-date "$(CURRENT_DATE)";
else
	@echo "feature project with example app"
	@mkdir -p Projects/Feature/${name};
	@tuist scaffold FeatureWithoutApp \
	--name ${name} \
	--author "$(USER_NAME)" \
	--current-date "$(CURRENT_DATE)";
endif
	@rm Pipfile >/dev/null 2>&1;
	@tuist edit
