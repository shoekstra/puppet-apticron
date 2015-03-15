[![Build Status](https://travis-ci.org/shoekstra/puppet-apticron.svg?branch=develop)](https://travis-ci.org/shoekstra/puppet-apticron)
[![Puppet Forge](http://img.shields.io/puppetforge/v/shoekstra/apticron.svg)](https://forge.puppetlabs.com/shoekstra/apticron)

apticron
========

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with apticron](#setup)
    * [What apticron affects](#what-apticron-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with apticron](#beginning-with-apticron)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

The apticron module installs and configures apticron - a simple script which sends daily emails about pending package updates.

## Module Description

The apticron module handles installing and configuring apticron on Debian-based distributions.  apticron will configure a cron job to email an administrator information about any packages on the system that have updates available, as well as a summary of changes in each package.

## Setup

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

### The `apticron` class

The `apticron` class configures the majority of options for this module.

#### Parameters

##### `custom_subject`

String: defaults to undef.  Set if you want to replace the default subject used in the notification e-mails.  This may help filtering/sorting client-side e-mail.

##### `cron_hour`

String: The hour at which to run the cron job. Optional; if specified, must be between 0 and 23, inclusive.

##### `cron_minute`

String: The minute at which to run the cron job. Optional; if specified, must be between 0 and 59, inclusive.

##### `cron_month`

String: The month of the year. Optional; if specified must be between 1 and 12 or the month name (e.g., December).

##### `cron_monthday`

String: The day of the month on which to run the command. Optional; if specified, must be between 1 and 31.

##### `cron_weekday`

String: The weekday on which to run the command. Optional; if specified, must be between 0 and 7, inclusive, with 0 (or 7) being Sunday, or must be the name of the day (e.g., Tuesday).

##### `diff_only`

Boolean: defaults to false.  Set to true to only output the difference of the current run compared to the last run (ie. only new upgrades since the last run).  If there are no differences, no output/email will be generated.  By default, apticron will output everything that needs to be upgraded.

##### `notify_holds`

Boolean: defaults to true.  Set to false if you don't want to be notified about new versions of packages on hold in your system.  The default behavior is downloading and listing them as any other package.

##### `notify_new`

Boolean: defaults to false.  Set to false if you don't want to be notified about packages which are not installed in your system. Yes, it's possible! There are some issues related to systems which have mixed stable/unstable sources.  In these cases apt-get will consider for example that packages with "Priority:required"/"Essential: yes" in unstable but not in stable should be installed, so they will be listed in dist-upgrade output.

##### `mail_from`

String: defaults to undef.  Set if you want to replace the default sender by changing the 'From:' field used in the notification e-mails.  Your default sender will be root@$fqdn.

## Reference

### Classes

#### Public Classes

* `apticron`: Guides the installation of apticron and configures apticron.conf.

#### Private Classes

* `apticron::config`: Configures apticron.
* `apticron::install`: Installs apticron.
* `apticron::params`: Manages apticron operating system specific parameters.

## Limitations

This module has been tested against Puppet 3.1 and higher.

The module has been tested on:

* Debian 6
* Debian 7
* Ubuntu 12.04
* Ubuntu 14.04

## Development

Pull requests welcome.

