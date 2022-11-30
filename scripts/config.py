from configparser import ConfigParser


CONTEXT_APPS = {
    'appnav': ['applicationNavigator',],
    'accessmgmt': ['BannerAccessMgmt', 'BannerAccessMgmt.ws',],
    'admincommon': ['BannerAdmin', 'BannerAdmin.ws',],
    'extz': ['BannerExtensibility',],
    'bcm': ['CommunicationManagement',],
    'employee': ['EmployeeSelfService',],
    'eeamc': ['ethosapimanagementcenter',],
    'financess': ['FinanceSelfService',],
    'general_ss': ['GeneralSelfService',],
}


# Makefile.local isn't exactly a .ini file like configparser epxects,
# but it's close enough for our purposes
MAKEFILE_LOCAL = ConfigParser()
with open('Makefile.local') as file:
    # configparser expects key-value pairs to be under bracketed headers
    MAKEFILE_LOCAL.read_string('[Makefile]\n' + file.read())
MAKEFILE_LOCAL = MAKEFILE_LOCAL['Makefile']
