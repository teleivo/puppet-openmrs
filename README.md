#puppet-openmrs

[![Build Status](https://secure.travis-ci.org/teleivo/puppet-openmrs.png?branch=master)](https://travis-ci.org/teleivo/puppet-openmrs)

####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with openmrs](#setup)
    * [Setup requirements](#setup-requirements)
    * [Beginning with openmrs](#beginning-with-openmrs)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development](#development)

##Overview

The openmrs module lets you use Puppet to deploy & configure openmrs on tomcat

##Module Description

OpenMRS is an open source enterprise electronic medical record system [OpenMRS](http://www.openmrs.org)
This module helps you in getting openmrs up and running using Puppet.

##Setup

###Setup requirements

The openmrs module requires
[puppetlabs-mysql](https://forge.puppetlabs.com/puppetlabs/mysql) version 3.1.0 or newer.
[puppetlabs-tomcat](https://forge.puppetlabs.com/puppetlabs/tomcat) version 1.3.2 or newer.
To install the modules do:

~~~
puppet module install puppetlabs-mysql
puppet module install puppetlabs-tomcat
~~~

**This module expects you to have java already installed.**
**This module expects that you have the packages needed by the 3rd party module (such as for ex. unzip, curl) already installed.**

###Beginning with openmrs

The simplest way to get openmrs up and running is to
install mysql server and tomcat on the same node as follows:

```puppet
include 'mysql::server'

class { 'tomcat':
  manage_user         => true,
  user                => 'tomcat7',
  install_from_source => false,
}->
tomcat::instance { 'tomcat7':
  package_name  => 'tomcat7',
}->
tomcat::service { 'tomcat7':
  use_init       => true,
  service_name   => 'tomcat7',
  service_ensure => running,
}->
class{ 'openmrs':
  tomcat_catalina_base => '/var/lib/tomcat7',
  tomcat_user          => 'tomcat7',
}
```

You can of course install mysql and tomcat on different nodes.

##Limitations

This module was only tested with openmrs version 1.11.4
This module is currently limited to Ubuntu 14.04 64bit.
This module is currently limited to openmrs using mysql.

##Development

Please feel free to open pull requests!

###Running tests
This project contains tests for [rspec-puppet](http://rspec-puppet.com/) to
verify functionality.

To install all dependencies for the testing environment:
```bash
sudo gem install bundler
bundle install
```

To run the tests once:
```bash
bundle exec rake spec
```
or if you also want lint, syntax checks
```bash
bundle exec rake test
```

To run the tests on any change of puppet files in the manifests folder:
```bash
bundle exec guard
```

