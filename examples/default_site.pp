Exec {
    path => [ '/usr/bin', '/bin', '/usr/sbin', '/sbin' ]
}

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
