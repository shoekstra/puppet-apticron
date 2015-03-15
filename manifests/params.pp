# == Class apticron::params
#
# This class is meant to be called from apticron.
# It sets variables according to platform.
#
class apticron::params {
  case $::osfamily {
    'Debian': {
      $conf_file = '/etc/apticron/apticron.conf'
      $conf_template = 'apticron/apticron.conf.erb'
      $package_name = 'apticron'
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
