class openmrs (
  $tomcat_catalina_base,
  $tomcat_user,
  $openmrs_application_data_directory = '/opt/openmrs',
  $db_host = 'localhost',
  $db_name = 'openmrs',
  $db_owner = 'openmrs',
  $db_owner_password = 'openmrs',
) {
  include 'tomcat'

  file { $openmrs_application_data_directory:
    ensure => 'directory',
    owner  => $tomcat_user,
    group  => $tomcat_user,
    mode   => '0755',
  }

  tomcat::war { 'openmrs.war':
    catalina_base => $tomcat_catalina_base,
    war_source    =>
    'http://sourceforge.net/projects/openmrs/files/releases/OpenMRS_Platform_1.11.4/openmrs.war',
    require       => File[$openmrs_application_data_directory],
  }

  mysql::db { $db_name:
    user     => $db_owner,
    password => $db_owner_password,
    host     => $db_host,
    grant    => ['ALL'],
  }
}
