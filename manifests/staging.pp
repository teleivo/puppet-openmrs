class openmrs::staging (
    $openmrs_version,
    $user,
    $user_home,
    $module_deployment_path,
) {
    $openmrs_archive_name = 'openmrs.war'

    $openmrs_base_url = 'http://sourceforge.net/projects/openmrs/files/releases/'
    $openmrs_base_url_suffix = "OpenMRS_${openmrs_version}"
    $openmrs_source_url = "${openmrs_base_url}${openmrs_base_url_suffix}/${openmrs_archive_name}"

    $openmrs_version_dir_suffix = regsubst($openmrs_version, "[.]", "_", "G")
    $openmrs_staging_dir = "${user_home}/openmrs_${openmrs_version_dir_suffix}/"
    $openmrs_staging_path = "${openmrs_staging_dir}${openmrs_archive_name}"

    class { '::staging':
        path  => $openmrs_staging_dir,
        owner => $user,
        group => $user,
    }

    staging::file { $openmrs_archive_name:
        source => $openmrs_source_url,
        target => $openmrs_staging_path,
    }

    file { "${module_deployment_path}/${openmrs_archive_name}":
        ensure  => present,
        owner   => $user,
        source  => $openmrs_staging_path,
        require => Staging::File["${openmrs_archive_name}"],
    }
}
