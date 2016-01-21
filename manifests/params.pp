# Parameters for puppet-barbican
#
class barbican::params {

  case $::osfamily {
    'RedHat': {
      $sqlite_package_name  = undef
      $pymysql_package_name = undef
    }
    'Debian': {
      $sqlite_package_name  = 'python-pysqlite2'
      $pymysql_package_name = 'python-pymysql'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem")
    }

  } # Case $::osfamily
}
