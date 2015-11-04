# puppet-openmrs

[![Build Status](https://secure.travis-ci.org/teleivo/puppet-openmrs.png?branch=master)](https://travis-ci.org/teleivo/puppet-openmrs)

#### Table of Contents

1. [Module Description - What the module does and why it is useful](#module-description)
2. [Setup - The basics of getting started with openmrs](#setup)
    * [Beginning with openmrs](#beginning-with-openmrs)
3. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
    * [Classes](#classes)
    * [Parameters](#parameters)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development](#development)

## Module Description

The OpenMRS module deploys and configures OpenMRS on [Tomcat](http://tomcat.apache.org/).  
[OpenMRS](http://www.openmrs.org) is an open source enterprise electronic medical record system.  

## Setup

### Beginning with OpenMRS

The quickest way to get OpenMRS up and running is to
install MySQL server and Tomcat on the same node, as done with the following on
an Ubuntu machine:

```puppet
include '::mysql::server'

class { '::tomcat':
  manage_user         => true,
  user                => 'tomcat7',
  install_from_source => false,
}->
::tomcat::instance { 'tomcat7':
  package_name  => 'tomcat7',
}->
::tomcat::service { 'tomcat7':
  use_init       => true,
  service_name   => 'tomcat7',
  service_ensure => running,
}->
class{ '::openmrs':
  tomcat_catalina_base               => '/var/lib/tomcat7',
  tomcat_user                        => 'tomcat7',
  openmrs_application_data_directory => '/var/lib/OpenMRS/',
}
```

## Reference

### Classes

#### Public classes

* [`openmrs`](#openmrs): Installs and configures OpenMRS.

#### Private classes

### Parameters

All parameters are optional except where otherwise noted.

#### openmrs

##### `tomcat_catalina_base`

*Required.* Specifies the base directory of the Tomcat installation where openmrs.war is
deployed.
Valid options: string containing an absolute path.

##### `tomcat_user`

*Required.* Specifies the user running Tomcat.
Valid options: string.

##### `openmrs_application_data_directory`

*Required.* Specifies the [application data directory](https://wiki.openmrs.org/display/docs/Application+Data+Directory) used used by OpenMRS for external storage. Directory owner and group are set to $tomcat_user.
Valid options: string containing an absolute path.

##### `db_host`

The host of the MySQL server.
Valid options: string.
Defaults to 'localhost'.

##### `db_name`

The MySQL database to create.
Valid options: string.
Defaults to 'openmrs'.

##### `db_owner`

The MySQL user for the database $db_name.
Valid options: string.
Defaults to 'openmrs'.

##### `db_owner_password`

The MySQL user password for $db_owner.
Valid options: string.
Defaults to 'openmrs'.

## Limitations

This module only deploys OpenMRS version 1.11.4.  
This module is currently limited to Ubuntu 14.04 64bit.  
This module is currently limited to OpenMRS using MySQL.  

## Development

Please feel free to open pull requests!

### Running tests
This project contains tests for [rspec-puppet](http://rspec-puppet.com/) to
verify functionality.

To install all dependencies for the testing environment:
```bash
sudo gem install bundler
bundle install
```

To run tests, lint and syntax checks once:
```bash
bundle exec rake test
```

To run the tests on any change of puppet files in the manifests folder:
```bash
bundle exec guard
```

