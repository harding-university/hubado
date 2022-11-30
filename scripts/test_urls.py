#!/usr/bin/env python3

import sys
import urllib
import urllib.request

from config import CONTEXT_APPS, MAKEFILE_LOCAL


for context, apps in CONTEXT_APPS.items():
    for app in apps:
        try:
            banner9_root = MAKEFILE_LOCAL['BANNER9_ROOT']
            res = urllib.request.urlopen(f'{banner9_root}/{app}/')
            status = res.status
            error = False
        except urllib.error.HTTPError as e:
            status = e.code
            error = True

        if error:
            sys.stdout.write('\033[0;31m')
        else:
            sys.stdout.write('\033[0;32m')
        print(status, app)
        sys.stdout.write('\033[0;m')
