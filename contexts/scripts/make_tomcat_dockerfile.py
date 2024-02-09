#!/usr/bin/env python3

import re
import sys

from jinja2 import Template

from config import CONTEXT_APPS, BANNER9_ROOT, HUBADO_HOST_UID, TIMEZONE


dockerfile_path = sys.argv[1]
context = re.match(r"contexts/(.*)/Dockerfile", dockerfile_path).groups()[0]

app_name = CONTEXT_APPS[context][0]

hubado_host_uid = HUBADO_HOST_UID
timezone = TIMEZONE

with open("/usr/local/share/Dockerfile_tomcat.j2") as f:
    template = Template(f.read())

print(
    template.render(
        app_name=app_name,
        context=context,
        hubado_host_uid=hubado_host_uid,
        timezone=timezone,
    )
)
