# == Class: barbican::params
#
# Parameters for puppet-barbican
#
class barbican::params {
  include ::openstacklib::defaults

  if ($::os_package_type == 'debian') {
    $pyvers = '3'
  } else {
    $pyvers = ''
  }

  $client_package_name   = "python${pyvers}-barbicanclient"
  $group                 = 'barbican'
  $dogtag_client_package = 'pki-base'

  case $::osfamily {
    'RedHat': {
      $api_package_name             = 'openstack-barbican-api'
      $api_service_name             = 'openstack-barbican-api'
      $worker_package_name          = 'openstack-barbican-worker'
      $worker_service_name          = 'openstack-barbican-worker'
      $barbican_wsgi_script_path    = '/var/www/cgi-bin/barbican'
      $barbican_wsgi_script_source  = '/usr/bin/barbican-wsgi-api'
      $httpd_config_file            = '/etc/httpd/conf.d/barbican-api.conf'
    }
    'Debian': {
      if ($::os_package_type == 'debian') {
        $api_service_name           = 'barbican-api'
      }
      $api_package_name             = 'barbican-api'
      $worker_package_name          = 'barbican-worker'
      $worker_service_name          = 'barbican-worker'
      $barbican_wsgi_script_path    = '/usr/lib/cgi-bin/barbican'
      $barbican_wsgi_script_source  = '/usr/bin/barbican-wsgi-api'
      $httpd_config_file            = '/etc/apache2/conf-available/barbican-api.conf'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operating system")
    }

  } # Case $::osfamily
}
