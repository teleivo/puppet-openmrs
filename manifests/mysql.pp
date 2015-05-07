class openmrs::mysql (
    $db_name,
    $db_owner,
    $db_owner_password,
    $db_host = localhost,
    $db_port = 3306,
) {

    include '::mysql::server'

    mysql::db { $db_name:
        user     => $db_owner,
        password => $db_owner_password,
        host     => $db_host,
        grant    => ['ALL'],
    }
}
