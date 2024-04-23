# Hubado

Hubado is a system for running [Ellucian
Banner](https://www.ellucian.com/solutions/ellucian-banner) components in a
Docker Compose environment. It integrates with Jenkins to function as an ESM
deploy target, and automatically configures and deploys the applications.

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

    -   Access Management
    -   Admin Common
    -   Application Navigator
    -   Communication Management
    -   Ellucian Ethos API Management Center
    -   Extensibility
    -   Integration API
    -   Student API
    -   Business Process API (beta)
    -   ...and more to come!


## Quick start

1.  Provision a Linux server to host the Hubado instance.

2.  In ESM's Jenkins instance, define a new node for the Hubado instance:

       1. Log in to Jenkins, click `Manage Jenkins`, then `Manage Nodes and
          Clouds`, and then `New Node`.
       2. Give the node a descriptive name, like `HUBADO`; select `Permanent
          Agent` and click `Create`. Fill in the following values:

           -   `Description`: the node's name
           -   `Remote root directory`: `/opt/jenkins`
           -   `Labels`: the node's name
           -   `Usage`: `Only build jobs with label expressions matching this
                node`

            Afterwards, click "Save".

3.  Click the node in the listing, and note the value passed to the `-secret`
    flag in the `Run from agent command line` box.

4.  In ESM and the environment this Hubado instance will run in, create a
    machine with a descriptive name, filling in the following values:

    - `Machine Role`: `App`
    - `Host Name`: your host servers's hostname
    - `IP`: your host system's IP
    - `Deployment Agent Name`: the Jenkins node name defined above
    - `IP` (again, under `Public Network): your host system's IP
    - `Banner 9 War File Staging Path`: `/deploy`

5.  Continuining in ESM, create a Tomcat app server with a descriptive name, with the follinwg values:

    - `Machine`: the machine defined above
    - `Catalina WebApps Path`: `/war`

6.  On the host server, install
    [Docker](https://docs.docker.com/engine/install/#server) and [Docker
    Compose](https://docs.docker.com/compose/install/).

7.  Run `git clone https://github.com/harding-university/hubado.git` and `cd
    hubado`.

8.  `cp Makefile.local.example Makefile.local` and edit `Makefile.local`,
    filling in values for your environment.

9.  Obtain `ojdbc8.jar` and `xdb6.jar` (such as from `$ORACLE_HOME/jdbc/lib/`
    on your Oracle server) and place in `vendor/`

10. Copy a SSL certificate for the URL given in `BANNER9_ROOT` in
    `Makefile.local` to `volumes/ssl/combined.pem`

11. Run `make images` to build the Docker images

12. Run `make up` to start the environment
