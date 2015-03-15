# == Class apticron::config
#
# This class is called from apticron for service config.
#
class apticron::config {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  file { '/etc/cron.d/apticron':
    ensure => absent,
    before => Cron['apticron']
  }

  $ensure = $::apticron::ensure ? {
    absent  => absent,
    default => present,
  }

  cron { 'apticron':
    ensure   => $ensure,
    minute   => $::apticron::cron_minute,
    hour     => $::apticron::cron_hour,
    monthday => $::apticron::cron_monthday,
    month    => $::apticron::cron_month,
    weekday  => $::apticron::cron_weekday,
    user     => 'root',
    command  => 'if test -x /usr/sbin/apticron; then /usr/sbin/apticron --cron; else true; fi',
  }

  # Used in config file
  $custom_subject = $::apticron::custom_subject
  $diff_only = $::apticron::diff_only
  $mail_from = $::apticron::mail_from
  $mail_to = $::apticron::mail_to
  $notify_holds = $::apticron::notify_holds
  $notify_new = $::apticron::notify_new

  file { $::apticron::conf_file:
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template($::apticron::conf_template)
  }
}
