# == Class apticron::config
# This class is meant to be called from apticron.
# It bakes the configuration file.
#
class apticron::config inherits apticron {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  file { $apticron::params::conf_file:
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template($apticron::conf_template)
  }
}
