## Technical make configuration ##

# Needed to use variables in prereqs, such as for the `contexts` target
.SECONDEXPANSION:

# Directories to copy files from (general make feature, not specific to this file)
VPATH = conf vendor volumes/jenkins/war

.PHONY: contexts images update-images \
	up stop down restart \
	jenkins haproxy \
	apis ssb9 \
	test \
	clean prune


## Compose command configuration ##
# Changes to any configuration should be done in Makefile.local (included below)

# Invocation of compose command
DOCKER_COMPOSE = docker compose -f compose.yaml

# Which profiles come up and down automatically with make up, make stop, etc.
AUTO_PROFILES = --profile endpoints --profile core


## Variable definitions ##

# List of tomcat contexts that should be given the stock TOMCAT_PREREQS
TOMCATS = \
	accessmgmt \
	admincommon \
	appnav \
	bcm \
	bep \
	bpapi \
	eeamc \
	ema \
	employee \
	extz \
	facss \
	financess \
	general_ss \
	geneventss \
	integrationapi \
	sss \
	studentapi \
	sturegss \

# The preqeqs specified in the following definitions will be pulled from
# the paths defiend in VPATHS above

# List of stock tomcat prereqs, given to every tomcat context
TOMCAT_PREREQS = \
	banner_configuration.groovy \
	context.xml \
	footer.groovy \
	ojdbc8.jar \
	server.xml \
	setenv.sh \

# Where WARs need to go; they will be copied from volumes/jenkins/war
CONTEXTS_WAR_PREREQS = \
	contexts/accessmgmt/BannerAccessMgmt.war \
	contexts/accessmgmt/BannerAccessMgmt.ws.war \
	contexts/admincommon/BannerAdmin.war \
	contexts/admincommon/BannerAdmin.ws.war \
	contexts/eeamc/ethosapimanagementcenter.war \
	contexts/appnav/applicationNavigator.war \
	contexts/bcm/CommunicationManagement.war \
	contexts/bep/BannerEventPublisher.war \
	contexts/bpapi/BannerAdminBPAPI.war \
	contexts/employee/EmployeeSelfService.war \
	contexts/extz/BannerExtensibility.war \
	contexts/facss/FacultySelfService.war \
	contexts/financess/FinanceSelfService.war \
	contexts/general_ss/BannerGeneralSsb.war \
	contexts/integrationapi/IntegrationApi.war \
	contexts/geneventss/SelfServiceBannerGeneralEventManagement.war \
	contexts/sss/StudentSelfService.war \
	contexts/studentapi/StudentApi.war \
	contexts/sturegss/StudentRegistrationSsb.war \

# Miscellaneous additional prereq files
CONTEXTS_ADDITIONAL_PREREQS = \
	contexts/extz/xdb6.jar \
	contexts/ema/EllucianMessagingAdapter.zip \
	contexts/integrationapi/footer_api.groovy \
	contexts/studentapi/footer_api.groovy \

# "Local" is the Hubado term for files generated from .dist template
# files; files specified will automatically be created from a
# corresponding .dist file, with variable substitution applied
LOCAL_FILES = \
	compose.yaml \
	contexts/accessmgmt/Dockerfile \
	contexts/bep/footer_bep.groovy \
	contexts/eeamc/Dockerfile \
	contexts/jenkins/Dockerfile \
	contexts/scripts/config.py \
	contexts/scripts/Dockerfile \
	volumes/ema/emsConfig.xml \
	volumes/jenkins/wgetrc \
	volumes/jenkins/start.sh \
	volumes/tomcat-env/env.properties \

# These Dockerfiles will be built from the template Dockerfile for
# Tomcat servers, contexts/scripts/Dockerfile_tomcat.j2
TOMCAT_DOCKERFILES = \
	contexts/admincommon/Dockerfile \
	contexts/appnav/Dockerfile \
	contexts/bcm/Dockerfile \
	contexts/bep/Dockerfile \
	contexts/bpapi/Dockerfile \
	contexts/ema/Dockerfile \
	contexts/employee/Dockerfile \
	contexts/extz/Dockerfile \
	contexts/facss/Dockerfile \
	contexts/financess/Dockerfile \
	contexts/general_ss/Dockerfile \
	contexts/geneventss/Dockerfile \
	contexts/integrationapi/Dockerfile \
	contexts/sss/Dockerfile \
	contexts/studentapi/Dockerfile \
	contexts/sturegss/Dockerfile \

# Include Makefile.local for environment-specific definitions and
# configuration changes
include Makefile.local


usage:
	@echo "usage: make [command]"
	@echo "Images must be built before \`make up\` will work."
	@echo ""
	@echo "Unless specified, commands only apply to Compose profiles defined in AUTO_PROFILES."
	@echo ""
	@echo "Commands:"
	@echo "    make contexts"
	@echo "    	Prepares contexts for manual building"
	@echo "    make images"
	@echo "    	Builds images (updating contexts automatically)"
	@echo "    make update-images"
	@echo "    	As above, but updates base images and dependencies"
	@echo ""
	@echo "    make up"
	@echo "    	Brings up containers"
	@echo "    make stop"
	@echo "    	Stops containers"
	@echo "    make down"
	@echo "    	Takes down *all* containers"
	@echo "    make restart"
	@echo "    	Runs down followed by up"
	@echo ""
	@echo "    make jenkins"
	@echo "    	Builds and starts the Jenkins node"
	@echo "    make haproxy"
	@echo "    	Builds and (re)starts HAProxy; useful for when a service restart changes its IP"
	@echo ""
	@echo "    make apis"
	@echo "    	Brings up the APIs profile"
	@echo "    make ssb9"
	@echo "    	Brings up the SSB9 profile"
	@echo ""
	@echo "    make test"
	@echo "    	Tests the HTTP status of services"
	@echo ""
	@echo "    make clean"
	@echo "    	Removes files derived from other files"
	@echo "    make prune"
	@echo "    	Removes Docker caches"


# Builds the images in AUTO_PROFILES
images: contexts
	$(DOCKER_COMPOSE) $(AUTO_PROFILES) build


# Rebuilds the images in AUTO_PROFILES, pulling latest base image and
# updating dependencies
update-images: contexts
	$(DOCKER_COMPOSE) $(AUTO_PROFILES)  build --no-cache --pull


up: $(LOCAL_FILES)
	$(DOCKER_COMPOSE) $(AUTO_PROFILES) up -d


stop:
	$(DOCKER_COMPOSE) $(AUTO_PROFILES) stop


down:
	$(DOCKER_COMPOSE) --profile "*" down


restart: down up


# Builds and starts jenkins
jenkins: user $(LOCAL_FILES)
	$(DOCKER_COMPOSE) build jenkins
	$(DOCKER_COMPOSE) up -d jenkins


# Builds an (re)starts haproxy
haproxy:
	$(DOCKER_COMPOSE) --profile endpoints build haproxy
	$(DOCKER_COMPOSE) --profile endpoints stop haproxy
	$(DOCKER_COMPOSE) --profile endpoints up -d haproxy


apis:
	$(DOCKER_COMPOSE) --profile apis up -d


ssb9:
	$(DOCKER_COMPOSE) --profile ssb9 up -d


clean:
	rm -f contexts/*/context.xml
	rm -f contexts/*/server.xml
	rm -f contexts/*/setenv.sh
	rm -f contexts/*/ojdbc8.jar
	rm -f contexts/*/xdb6.jar
	rm -f contexts/*/*.trz
	rm -f contexts/*/footer.groovy
	rm -f contexts/*/banner_configuration.groovy
	rm -f $(CONTEXTS_WAR_PREREQS)
	rm -f $(CONTEXTS_ADDITIONAL_PREREQS)
	rm -f $(LOCAL_FILES)
	rm -f $(TOMCAT_DOCKERFILES)


prune:
	docker container prune -f
	docker network prune -f
	docker image prune -f
	docker system prune -f


test:
	$(DOCKER_COMPOSE) run --rm scripts test_urls.py


## Technical targets ##


# Builds the scripts service; used in building other contexts
scripts: scripts-context user
	$(DOCKER_COMPOSE) build scripts


# The scripts service is used to build other contexts, so we define its
# prereqs here instead of as part of contexts below
scripts-context: contexts/scripts/Dockerfile contexts/scripts/config.py


# Create a prereq for each combination of tomcat context and tomcat prereq
contexts: $(foreach tomcat,$(TOMCATS),$(foreach prereq,$(TOMCAT_PREREQS),contexts/$(tomcat)/$(prereq)))
# Add additional prereqs to the `contexts` target
contexts: $(CONTEXTS_WAR_PREREQS)
contexts: $(CONTEXTS_ADDITIONAL_PREREQS)
contexts: $(LOCAL_FILES)
contexts: scripts
contexts: $(TOMCAT_DOCKERFILES)


contexts/ema/EllucianMessagingAdapter.zip:
	cp vendor/EllucianMessagingAdapter*.zip $@


# This rule says to copy any prereq within contexts/ from the `VPATH` directories 
contexts/%: $$(notdir %)
	cp $< $@


# This creates files from .dist templaces, substituting any ^VARIABLE^
# in .dist files with the values defined in Makefile.local
$(LOCAL_FILES): $$(@).dist Makefile.local
	cp $< $@
	echo Replacing variables in $@...
	@sed -i "s,\^BANNER9_ROOT\^,$(BANNER9_ROOT)," $@
	@sed -i "s/\^BANNER9_PROXY_USER\^/$(BANNER9_PROXY_USER)/" $@
	@sed -i "s/\^BANNER9_PROXY_PASSWORD\^/$(BANNER9_PROXY_PASSWORD)/" $@
	@sed -i "s/\^BANNER9_CONNECTION_USER\^/$(BANNER9_CONNECTION_USER)/" $@
	@sed -i "s/\^BANNER9_CONNECTION_PASSWORD\^/$(BANNER9_CONNECTION_PASSWORD)/" $@
	@sed -i "s/\^BANNER9_SESSION_TIMEOUT\^/$(BANNER9_SESSION_TIMEOUT)/" $@
	@sed -i "s/\^ORACLE_HOST\^/$(ORACLE_HOST)/" $@
	@sed -i "s/\^ORACLE_SID\^/$(ORACLE_SID)/" $@
	@sed -i "s/\^ORACLE_SERVICE_NAME\^/$(ORACLE_SERVICE_NAME)/" $@
	@sed -i "s,\^CAS_URL\^,$(CAS_URL)," $@
	@sed -i "s,\^CAS_LOGOUT_URL\^,$(CAS_LOGOUT_URL)," $@
	@sed -i "s,\^JENKINS_URL\^,$(JENKINS_URL)," $@
	@sed -i "s,\^JENKINS_NODE\^,$(JENKINS_NODE)," $@
	@sed -i "s,\^JENKINS_SECRET\^,$(JENKINS_SECRET)," $@
	@sed -i "s,\^ESM_WGET_USER\^,$(ESM_WGET_USER)," $@
	@sed -i "s,\^ESM_WGET_PASSWORD\^,$(ESM_WGET_PASSWORD)," $@
	@sed -i "s/\^HUBADO_HOST_USER\^/$(HUBADO_HOST_USER)/" $@
	@sed -i "s/\^HUBADO_HOST_UID\^/`id -u $(HUBADO_HOST_USER)`/" $@
	@sed -i "s,\^TIMEZONE\^,$(TIMEZONE)," $@
	@sed -i "s/\^INSTITUTION_NAME\^/$(INSTITUTION_NAME)/" $@
	@sed -i "s/\^GRAFANA_USER\^/$(GRAFANA_USER)/" $@
	@sed -i "s/\^GRAFANA_PASSWORD\^/$(GRAFANA_PASSWORD)/" $@
	@sed -i "s/\^GRAFANA_SMTP_HOST\^/$(GRAFANA_SMTP_HOST)/" $@
	@sed -i "s/\^EMS_USER\^/$(EMS_USER)/" $@
	@sed -i "s/\^EMS_PASSWORD\^/$(EMS_PASSWORD)/" $@
	@sed -i "s/\^EMS_ENCRYPTED_PASSWORD\^/$(EMS_ENCRYPTED_PASSWORD)/" $@
	@sed -i "s/\^EMS_HOST\^/$(EMS_HOST)/" $@
	@sed -i "s/\^CDCADMIN_PASSWORD\^/$(CDCADMIN_PASSWORD)/" $@
	@sed -i "s/\^EVENTS_PASSWORD\^/$(EVENTS_PASSWORD)/" $@
	@sed -i "s/\^COMMMGR_PASSWORD\^/$(COMMMGR_PASSWORD)/" $@
	@sed -i "s/\^EMA_KEY\^/$(EMA_KEY)/" $@
	@sed -i "s/\^API_USER_USER\^/$(API_USER_USER)/" $@
	@sed -i "s/\^API_USER_PASSWORD\^/$(API_USER_PASSWORD)/" $@
	@sed -i "s/\^ETHOS_INTEGRATION_KEY\^/$(ETHOS_INTEGRATION_KEY)/" $@
	@sed -i "s/\^ETHOS_STUDENT_KEY\^/$(ETHOS_STUDENT_KEY)/" $@


# This builds Tomcat Dockerfiles with the Dockerfile_tomcat.j2 template
$(TOMCAT_DOCKERFILES): \
		contexts/scripts/make_tomcat_dockerfile.py \
		contexts/scripts/Dockerfile_tomcat.j2 \
		Makefile.local \
		scripts-context
	$(DOCKER_COMPOSE) run --rm scripts make_tomcat_dockerfile.py $@ > $@


# This creates the user that is used within the containers
user:
	sudo useradd -r $(HUBADO_HOST_USER) || true
	sudo chown -R $(HUBADO_HOST_USER) volumes/


# vim: set noexpandtab sts=0:
