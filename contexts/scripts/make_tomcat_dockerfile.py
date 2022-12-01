#!/usr/bin/env python3

import re
import sys

from jinja2 import Template

from config import CONTEXT_APPS, TIMEZONE


dockerfile_path = sys.argv[1]
context = re.match(r'contexts/(.*)/Dockerfile', dockerfile_path).groups()[0]

assert context in ['appnav']
assert len(CONTEXT_APPS[context]) == 1

with open('/usr/local/share/Dockerfile_tomcat.j2') as f:
    template = Template(f.read())

app_name = CONTEXT_APPS[context][0]
timezone = TIMEZONE

print(template.render(
    app_name=app_name,
    timezone=timezone,
))
