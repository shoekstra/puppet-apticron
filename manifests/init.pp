# == Class: apticron
#
# Simple tool to mail about pending package updates.
#
# === Parameters
#
# [*mail_to*]
#   Set to a space separated list of addresses which will be notified of
#   impending updates
#
# [*diff_only*]
#   Set to true to only output the difference of the current run compared
#   to the last run (ie. only new upgrades since the last run). If there
#   are no differences, no output/email will be generated. By default,
#   apticron will output everything that needs to be upgraded.
#
# [*notify_holds*]
#   Set to false if you don't want to be notified about new versions of
#   packages on hold in your system. The default behavior is downloading
#   and listing them as any other package.
#
# [*notify_new*]
#   Set to false if you don't want to be notified about packages which
#   are not installed in your system. Yes, it's possible! There are some
#   issues related to systems which have mixed stable/unstable sources.
#   In these cases apt-get will consider for example that packages with
#   "Priority:required"/"Essential: yes" in unstable but not in stable
#   should be installed, so they will be listed in dist-upgrade output.
#
# [*custom_subject*]
#   Set if you want to replace the default subject used in the notification
#   e-mails. This may help filtering/sorting client-side e-mail.  If you
#   want to use internal vars please use single quotes here. Ex:
#   '[apticron] $SYSTEM: $NUM_PACKAGES package update(s)'
#
# [*mail_from*]
#   Set if you want to replace the default sender by changing the 'From:'
#   field used in the notification e-mails. Your default sender will
#   be root@$fqdn
#
# === Examples
#
# class { '::apticron': mail_to => 'sysadmin@example.com' }
#
class apticron (
    $mail_to,
    $diff_only = false,
    $notify_holds = true,
    $notify_new = false,
    $custom_subject = undef,
    $mail_from = undef,
) inherits apticron::params {

  validate_bool($diff_only)
  validate_bool($notify_holds)
  validate_bool($notify_new)

  class { 'apticron::install': } ->
  class { 'apticron::config': } ~>
  class { 'apticron::cron': } ~>
  Class['apticron']
}
