class openmrs::staging (
) {
    $openmrs_archive_name = 'openmrs.war'

    $openmrs_base_url = 'http://sourceforge.net/projects/openmrs/files/releases/'
    $openmrs_base_url_suffix = "OpenMRS_${openmrs::version}"
    $openmrs_source_url = "${openmrs_base_url}${openmrs_base_url_suffix}/${openmrs_archive_name}"

    $openmrs_version_dir_suffix = regsubst($openmrs::version, "[.]", "_", "G")
    $openmrs_staging_dir = "${openmrs::user_home}/openmrs_${openmrs_version_dir_suffix}/"
    $openmrs_staging_path = "${openmrs_staging_dir}${openmrs_archive_name}"

    file { $openmrs_staging_dir:
        ensure => directory,
        owner  => $openmrs::user,
        group  => $openmrs::user,
    }

    staging::file { $openmrs_archive_name:
        source  => $openmrs_source_url,
        target  => $openmrs_staging_path,
        require => File["${openmrs_staging_dir}"],
    }

    file { "${openmrs::tomcat_module_deployment_path}/${openmrs_archive_name}":
        ensure  => present,
        owner   => $openmrs::user,
        source  => $openmrs_staging_path,
        require => Staging::File["${openmrs_archive_name}"],
    }
}
