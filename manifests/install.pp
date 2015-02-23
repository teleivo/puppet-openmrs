class openmrs197::install (
    $user,
    $user_home,
    $module_deployment_path,
    $db_type,
    $db_name,
    $db_owner,
    $db_owner_password,
) {
    $openmrs_version = '1.9.7'
    $openmrs_archive_name = "openmrs.war"

    $openmrs_base_url = 'http://sourceforge.net/projects/openmrs/files/releases/'
    $openmrs_base_url_suffix = "OpenMRS_${openmrs_version}"
    $openmrs_wget_url = "${openmrs_base_url}${openmrs_base_url_suffix}/${openmrs_archive_name}"

    $openmrs_wget_dest_path = "${user_home}/${openmrs_archive_name}"

    exec { 'wget_openmrs':
        cwd     => "${user_home}",
        user    => "${user}",
        group   => "${user}",
        path    => '/usr/bin',
        timeout => 600,
        creates => "${openmrs_wget_dest_path}",
        command => "wget ${openmrs_wget_url} -O ${openmrs_archive_name}"
    }->

    file { "${module_deployment_path}/${openmrs_archive_name}":
        ensure  => present,
        owner   => "${user}",
        source  => "${openmrs_wget_dest_path}",
    }->

    class { 'openmrs197::mysql::create_db':
        db_name             => "${db_name}",
        db_owner            => "${db_owner}",
        db_owner_password   => "${db_owner_password}",
    }
}
