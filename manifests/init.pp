class openmrs (
  $tomcat_catalina_base,
  $tomcat_user,
  $openmrs_application_data_directory = '/opt/openmrs',
  $db_host = 'localhost',
  $db_name = 'openmrs',
  $db_owner = 'openmrs',
  $db_owner_password = 'openmrs',
) {
  $openmrs_runtime_properties_filename = 'openmrs-runtime.properties'
  $openmrs_runtime_properties_path =
  "${openmrs::tomcat_catalina_base}/${openmrs_runtime_properties_filename}"
  
  $openmrs_runtime_properties = {
    'connection.url'         =>
    "jdbc:mysql://${openmrs::db_host}:3306/${openmrs::db_name}?autoReconnect=true&sessionVariables=storage_engine=InnoDB&useUnicode=true&characterEncoding=UTF-8",
    'connection.username'    => $openmrs::db_owner,
    'connection.password'    => $openmrs::db_owner_password,
    'auto_update_database'   => false,
    'module.allow_web_admin' => true,
  }

  include 'tomcat'

  tomcat::war { 'openmrs.war':
    catalina_base => $openmrs::tomcat_catalina_base,
    war_source    =>
    'http://sourceforge.net/projects/openmrs/files/releases/OpenMRS_Platform_1.11.4/openmrs.war',
    require       => [ File[$openmrs_runtime_properties_path],
                      File[$openmrs::openmrs_application_data_directory] ]
  }
  file { $openmrs_runtime_properties_path:
    ensure  => present,
    owner   => $openmrs::tomcat_user,
    group   => $openmrs::tomcat_user,
    mode    => '0644',
    content =>
      template("openmrs/${openmrs_runtime_properties_filename}.erb"),
  }
  file { $openmrs::openmrs_application_data_directory:
    ensure => 'directory',
    owner  => $openmrs::tomcat_user,
    group  => $openmrs::tomcat_user,
    mode   => '0755',
  }

  mysql::db { $openmrs::db_name:
    user     => $openmrs::db_owner,
    password => $openmrs::db_owner_password,
    host     => $openmrs::db_host,
    grant    => ['ALL'],
  }
}
