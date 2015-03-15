# == Class apticron::install
#
# This class is called from apticron for install.
#
class apticron::install {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  package { $::apticron::package_name:
    ensure => $::apticron::ensure,
  }
}
