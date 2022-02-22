# == Class: barbican::params
#
# Parameters for puppet-barbican
#
class barbican::params {
  include openstacklib::defaults

  $client_package_name   = 'python3-barbicanclient'
  $user                  = 'barbican'
  $group                 = 'barbican'
  $dogtag_client_package = 'pki-base'

  case $::osfamily {
    'RedHat': {
      $api_package_name               = 'openstack-barbican-api'
      $api_service_name               = 'openstack-barbican-api'
      $worker_package_name            = 'openstack-barbican-worker'
      $worker_service_name            = 'openstack-barbican-worker'
      $keystone_listener_package_name = 'openstack-barbican-keystone-listener'
      $keystone_listener_service_name = 'openstack-barbican-keystone-listener'
      $barbican_wsgi_script_path      = '/var/www/cgi-bin/barbican'
      $barbican_wsgi_script_source    = '/usr/bin/barbican-wsgi-api'
    }
    'Debian': {
      $api_service_name               = 'barbican-api'
      $api_package_name               = 'barbican-api'
      $worker_package_name            = 'barbican-worker'
      $worker_service_name            = 'barbican-worker'
      $keystone_listener_package_name = 'barbican-keystone-listener'
      $keystone_listener_service_name = 'barbican-keystone-listener'
      $barbican_wsgi_script_path      = '/usr/lib/cgi-bin/barbican'
      $barbican_wsgi_script_source    = '/usr/bin/barbican-wsgi-api'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operating system")
    }

  } # Case $::osfamily
}
