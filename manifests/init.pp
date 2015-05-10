class openmrs (
    $version = '1.9.7',
    $tomcat_user = 'tomcat6',
    $tomcat_user_home = '/opt/tomcat6',
    $tomcat_module_deployment_path = '/opt/tomcat6/apache-tomcat-6.0.29/webapps',
    $db_host = 'localhost',
    $db_name = 'openmrs',
    $db_owner = 'openmrs',
    $db_owner_password = 'openmrs',
) {
    include tomcat6

    package { 'openjdk-7-jdk':
        ensure => present,
    }

    package { 'libaio1':
        ensure => present,
    }

    class { 'openmrs::staging':
    }

    mysql::db { $openmrs::db_name:
        user     => $openmrs::db_owner,
        password => $openmrs::db_owner_password,
        host     => $openmrs::db_host,
        grant    => ['ALL'],
    }
}
