# == Class apticron::params
#
# This class is meant to be called from apticron
# It sets variables according to platform
#
class apticron::params {
  case $::osfamily {
    'Debian': {
      $conf_file = '/etc/apticron/apticron.conf'
      $conf_template = 'apticron/apticron.conf.erb'
      $package = 'apticron'
    }
    default: {
      fail("${module_name} module not supported on ${::osfamily} osfamily")
    }
  }
}
