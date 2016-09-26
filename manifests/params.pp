# Parameters for puppet-barbican
#
class barbican::params {
  include ::openstacklib::defaults

  case $::osfamily {
    'RedHat': {
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
      $api_package_name             = 'barbican-api'
      $worker_package_name          = 'barbican-worker'
      $worker_service_name          = 'barbican-worker'
      $client_package_name          = 'python-barbicanclient'
      $barbican_wsgi_script_path    = '/usr/lib/cgi-bin/barbican'
      $barbican_wsgi_script_source  = '/usr/lib/python2.7/dist-packages/barbican/api/app.wsgi'
      $dogtag_client_package        = 'pki-base'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operating system")
    }

  } # Case $::osfamily
}
