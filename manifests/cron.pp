# == Class: apticron::cron
#
# Manage apticron cronjob using standard cron function parameters (http://docs.puppetlabs.com/references/latest/type.html#cron).
#
# === Examples
#
# class { '::apticron::cron':
#   ensure => present,
#   minute => 0,
#   hour   => 1
# }
#
class apticron::cron (
    $ensure = present,
    $minute = 15,
    $hour = '*',
    $monthday = '*',
    $month = '*',
    $weekday = '*',
) {

  file { '/etc/cron.d/apticron':
    ensure => absent
  } ->

  cron { 'apticron':
    ensure   => $ensure,
    minute   => $minute,
    hour     => $hour,
    monthday => $monthday,
    month    => $month,
    weekday  => $weekday,
    user     => 'root',
    command  => 'if test -x /usr/sbin/apticron; then /usr/sbin/apticron --cron; else true; fi',
  }
}
