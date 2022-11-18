import sys
import urllib
import urllib.request
from configparser import ConfigParser


WEBAPPS = [
    'applicationNavigator',
    'BannerAccessMgmt',
    'BannerAccessMgmt.ws',
    'BannerAdmin',
    'BannerAdmin.ws',
    'BannerExtensibility',
    'CommunicationManagement',
    'EmployeeSelfService',
    'ethosapimanagementcenter',
    'FinanceSelfService',
    'GeneralSelfService',
]


# Makefile.local isn't exactly a .ini file like configparser epxects,
# but it's close enough for our purposes
config = ConfigParser()
with open('Makefile.local') as makefile_local:
    # configparser expects key-value pairs to be under bracketed headers
    config.read_string('[Makefile]\n' + makefile_local.read())

banner9_root = config['Makefile']['BANNER9_ROOT']


for webapp in WEBAPPS:
    try:
        res = urllib.request.urlopen(f'{banner9_root}/{webapp}/')
        status = res.status
        error = False
    except urllib.error.HTTPError as e:
        status = e.code
        error = True

    if error:
        sys.stdout.write('\033[0;31m')
    else:
        sys.stdout.write('\033[0;32m')
    print(status, webapp)
    sys.stdout.write('\033[0;m')
