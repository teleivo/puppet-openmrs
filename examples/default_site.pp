Exec {
    path => [ "/usr/bin", "/bin", "/usr/sbin", "/sbin" ]
}

include 'mysql::server'

include openmrs

