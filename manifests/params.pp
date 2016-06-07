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
      $barbican_wsgi_script_source  = '/usr/lib/python2.7/site-packages/barbican/api/app.wsgi'
      $dogtag_client_package        = 'pki-base'
    }
    'Debian': {
      $package_name                 = 'openstack-barbican'
      $service_name                 = 'openstack-barbican'
      $client_package_name          = 'python-barbicanclient'
      $barbican_wsgi_script_path    = '/var/www/cgi-bin/barbican'
      $barbican_wsgi_script_source  = '/usr/lib/python2.7/site-packages/barbican/api/app.wsgi'
      $dogtag_client_package        = 'pki-base'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operating system")
    }

  } # Case $::osfamily
}
