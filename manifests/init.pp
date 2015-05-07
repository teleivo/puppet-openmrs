class openmrs (
    $tomcat_user = 'tomcat6',
    $tomcat_user_home = '/opt/tomcat6',
    $tomcat_module_deployment_path = '/opt/tomcat6/apache-tomcat-6.0.29/webapps',
    $db_name = 'openmrs',
    $db_owner = 'openmrs',
    $db_owner_password = 'openmrs',
) {
    include tomcat6

    package { "openjdk-7-jdk":
        ensure => "present",
    }

    package { "libaio1":
        ensure => "present",
    }

    class { 'openmrs::staging':
        user                    => $tomcat_user,
        user_home               => $tomcat_user_home,
        module_deployment_path  => $tomcat_module_deployment_path,
    }

    class { 'openmrs::mysql':
        db_name             => $db_name,
        db_owner            => $db_owner,
        db_owner_password   => $db_owner_password,
    }
}
