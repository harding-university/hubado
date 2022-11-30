#!/usr/bin/env python3

import re
import sys

from config import CONTEXT_APPS, MAKEFILE_LOCAL


dockerfile_path = sys.argv[1]
context = re.match(r'contexts/(.*)/Dockerfile', dockerfile_path).groups()[0]

assert context in ['appnav']
assert len(CONTEXT_APPS[context]) == 1

with open('templates/tomcat.dockerfile') as f:
    template = f.read()

app_name = CONTEXT_APPS[context][0]
timezone = MAKEFILE_LOCAL['timezone']
dockerfile = template.format(
    app_name=app_name,
    timezone=timezone,
)

with open(dockerfile_path, 'w') as f:
    f.write(dockerfile)
