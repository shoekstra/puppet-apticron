# == Class apticron::install
#
class apticron::install {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  package { $apticron::package:
    ensure => present,
  }
}
