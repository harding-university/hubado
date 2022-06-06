# Hubado

Hubado is a system for running [Ellucian
Banner](https://www.ellucian.com/solutions/ellucian-banner) components in a
Docker Compose environment.

*Hubado is a project maintained by [Harding
University](https://www.harding.edu), and is unaffiliated with Ellucian. It is
in use at Harding, but should be considered experimental at present. Hubado is
released under the [MIT license](LICENSE).*

## Features

-   Keep your environment configuration in a single file, and stop plugging the
    same information into multiple `config.properties` and
    `*configuration.groovy` files
-   Standardize your Tomcat configuration across components and environments
-   Single-command startups, shutdowns, and restarts of the entire environment,
    with optional scripts provided for automating restarts
-   Single-command update of all Tomcat servers in environment
-   Collaborate with other universities on configuration
-   Supported Banner components:
    -   Application Navigator
    -   Admin Common
    -   Extensibility
    -   Communication Management
    -   Access Management
    -   Ellucian Ethos API Management Center
    -   ...and more to come!

## Quick start

*Note: this description ignores the Jenkins container and ESM integration, which
is being removed but is required for the moment (see [issue #1](https://github.com/harding-university/hubado/issues/1)).*

On a Linux server, do the following:

-   Install [Docker](https://docs.docker.com/engine/install/#server) and [Docker
    Compose](https://docs.docker.com/compose/install/)
-   `git clone https://github.com/harding-university/hubado.git` and `cd
    hubado`
-   `cp Makefile.local.example Makefile.local` and edit `Makefile.local`,
    filling in values for your environment
-   Obtain `ojdbc8.jar` and `xdb6.jar` (such as from `$ORACLE_HOME/jdbc/lib/` on
    your Oracle server) and place in `vendor/`
-   Copy the relevant `*u.trz` Banner upgrade artifacts to `artifacts` (or just
    mount your ESM instance's `UpgradeArtifacts` directory)
-   Copy a SSL certificate for the URL given in `BANNER9_ROOT` in
    `Makefile.local` to `volumes/ssl/combined.pem`
-   Run `make images` to build the Docker images
-   Run `make up` to start the environment
