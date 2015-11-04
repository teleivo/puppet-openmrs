# Class: openmrs: See README.md for documentation.
class openmrs (
  $tomcat_catalina_base,
  $tomcat_user,
  $openmrs_application_data_directory,
  $db_host = 'localhost',
  $db_name = 'openmrs',
  $db_owner = 'openmrs',
  $db_owner_password = 'openmrs',
) {
  validate_absolute_path($tomcat_catalina_base)
  validate_string($tomcat_user)
  validate_absolute_path($openmrs_application_data_directory)
  validate_string($db_host)
  validate_string($db_name)
  validate_string($db_owner)
  validate_string($db_owner_password)

  include '::tomcat'

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
