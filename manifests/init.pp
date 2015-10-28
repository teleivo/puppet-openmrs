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
  "${tomcat_catalina_base}/${openmrs_runtime_properties_filename}"
  
  $openmrs_runtime_properties = {
    'connection.url'         =>
    "jdbc:mysql://${db_host}:3306/${db_name}?autoReconnect=true&sessionVariables=storage_engine=InnoDB&useUnicode=true&characterEncoding=UTF-8",
    'connection.username'        => $db_owner,
    'connection.password'        => $db_owner_password,
    'auto_update_database'       => false,
    'module.allow_web_admin'     => true,
    'application_data_directory' => $openmrs_application_data_directory,
  }

  include 'tomcat'

  tomcat::war { 'openmrs.war':
    catalina_base => $tomcat_catalina_base,
    war_source    =>
    'http://sourceforge.net/projects/openmrs/files/releases/OpenMRS_Platform_1.11.4/openmrs.war',
    require       => [ File[$openmrs_runtime_properties_path],
                      File[$openmrs_application_data_directory]
    ]
  }
  file { $openmrs_runtime_properties_path:
    ensure  => present,
    owner   => $tomcat_user,
    group   => $tomcat_user,
    mode    => '0644',
    content =>
      template("openmrs/${openmrs_runtime_properties_filename}.erb"),
  }
  file { $openmrs_application_data_directory:
    ensure => 'directory',
    owner  => $tomcat_user,
    group  => $tomcat_user,
    mode   => '0755',
  }

  mysql::db { $db_name:
    user     => $db_owner,
    password => $db_owner_password,
    host     => $db_host,
    grant    => ['ALL'],
  }
}
