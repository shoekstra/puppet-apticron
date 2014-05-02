####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with apticron](#setup)
    * [What apticron affects](#what-apticron-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with apticron](#beginning-with-apticron)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

##Overview

The apticron module installs and configures apticron - a simple script which sends daily emails about pending package updates.

##Module Description

The apticron module handles installing and configuring apticron on Debian-based distributions.  apticron will configure a cron job to email an administrator information about any packages on the system that have updates available, as well as a summary of changes in each package.

##Setup

### What apticron affects

* Installs apticron package
* Removes /etc/cron.d/apticron in order to manage the cron job using the puppet cron function
* Configures /etc/apticron/apticron.conf

### Beginning with apticron

To install apticron with it's most minimal config:

```puppet
class { '::apticron':
  mail_to => 'sysadmin@example.com'
}
```

This will configure apticron to send reports daily to sysadmin@example.com.

## Usage

### The `::apticron::` class

The `apticron` class configures the majority of options for this module.

#### Parameters

##### `diff_only`

Boolean: defaults to false.  Set to true to only output the difference of the current run compared to the last run (ie. only new upgrades since the last run).  If there are no differences, no output/email will be generated.  By default, apticron will output everything that needs to be upgraded.

##### `notify_holds`

Boolean: defaults to true.  Set to false if you don't want to be notified about new versions of packages on hold in your system.  The default behavior is downloading and listing them as any other package.

##### `notify_new`

Boolean: defaults to false.  Set to false if you don't want to be notified about packages which are not installed in your system. Yes, it's possible! There are some issues related to systems which have mixed stable/unstable sources.  In these cases apt-get will consider for example that packages with "Priority:required"/"Essential: yes" in unstable but not in stable should be installed, so they will be listed in dist-upgrade output.

##### `custom_subject`

String: defaults to undef.  Set if you want to replace the default subject used in the notification e-mails.  This may help filtering/sorting client-side e-mail.

##### `mail_from`

String: defaults to undef.  Set if you want to replace the default sender by changing the 'From:' field used in the notification e-mails.  Your default sender will be root@$fqdn.

### The `apticron::cron` class

The `apticron::cron` class removes the /etc/cron.d/apticron file, replacing it with a root crontab entry using the [Puppet cron function](http://docs.puppetlabs.com/references/latest/type.html#cron).  The following parameters are configurable: minute, hour, monthday, month, weekday.

##Limitations

This module has been tested against Puppet 3.1 and higher.

The module has been tested on:

* Ubuntu 12.04

##Development

Pull requests welcome.

[![githalytics.com alpha](https://cruel-carlota.pagodabox.com/0e64e10b06caf95c9900623996f00d60 "githalytics.com")](http://githalytics.com/shoekstra/puppet-apticron)
