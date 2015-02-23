class openmrs197 (
    $version = '6.0.29',
    $tomcat_user = 'tomcat6',
    $tomcat_user_home = '/opt/tomcat6',
    $tomcat_http_port = '8080',
    $db_type = 'mysql',
    $db_name = 'openmrs',
    $db_owner = 'openmrs',
    $db_owner_password = 'openmrs',
) {

    $tomcat_module_deployment_path = "${tomcat_user_home}/apache-tomcat-6.0.29/webapps"

    package { "openjdk-7-jdk":
        ensure => "present",
    }->

    package { "libaio1":
        ensure => "present",
    }->

    class { 'tomcat6':
        user      => $tomcat_user,
        user_home => $tomcat_user_home,
        http_port => $tomcat_http_port,
    }

    class { 'openmrs197::install':
        user                    => $tomcat_user,
        user_home               => $tomcat_user_home,
        module_deployment_path  => $tomcat_module_deployment_path,
        db_type                 => $db_type,
        db_name                 => $db_name,
        db_owner                => $db_owner,
        db_owner_password       => $db_owner_password,
        require                 => Class['tomcat6'],
    }
}
