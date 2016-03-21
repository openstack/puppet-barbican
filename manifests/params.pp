# Parameters for puppet-barbican
#
class barbican::params {

  case $::osfamily {
    'RedHat': {
      $package_name                 = 'openstack-barbican'
      $api_package_name             = 'openstack-barbican-api'
      $api_service_name             = 'openstack-barbican-api'
      $worker_package_name          = 'openstack-barbican-worker'
      $worker_service_name          = 'openstack-barbican-worker'
      $client_package_name          = 'python-barbicanclient'
      $barbican_wsgi_script_path    = '/var/www/cgi-bin/barbican'
      $sqlite_package_name          = undef
      $barbican_wsgi_script_source  = '/usr/share/barbican/barbican.wsgi'
      $paste_config                 = '/etc/barbican/barbican-api-paste.ini'
      $dogtag_client_package        = 'pki-base'
      $pymysql_package_name = undef
    }
    'Debian': {
      $package_name                 = 'openstack-barbican'
      $service_name                 = 'openstack-barbican'
      $client_package_name          = 'python-barbicanclient'
      $barbican_wsgi_script_path    = '/var/www/cgi-bin/barbican'
      $sqlite_package_name          = 'python-pysqlite2'
      $barbican_wsgi_script_source  = '/usr/share/barbican/barbican.wsgi'
      $paste_config                 = '/etc/barbican/barbican-api-paste.ini'
      $dogtag_client_package        = 'pki-base'
      $pymysql_package_name = 'python-pymysql'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operating system")
    }

  } # Case $::osfamily
}
