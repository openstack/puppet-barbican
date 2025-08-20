# == Class: barbican::params
#
# Parameters for puppet-barbican
#
class barbican::params {
  include openstacklib::defaults

  $pyver3 = $openstacklib::defaults::pyver3

  $client_package_name   = 'python3-barbicanclient'
  $user                  = 'barbican'
  $group                 = 'barbican'
  $dogtag_client_package = 'pki-base'

  case $facts['os']['family'] {
    'RedHat': {
      $common_package_name            = 'openstack-barbican-common'
      $api_package_name               = 'openstack-barbican-api'
      $api_service_name               = 'openstack-barbican-api'
      $worker_package_name            = 'openstack-barbican-worker'
      $worker_service_name            = 'openstack-barbican-worker'
      $keystone_listener_package_name = 'openstack-barbican-keystone-listener'
      $keystone_listener_service_name = 'openstack-barbican-keystone-listener'
      $retry_package_name             = 'openstack-barbican-retry'
      $retry_service_name             = 'openstack-barbican-retry'
      $barbican_wsgi_script_path      = '/var/www/cgi-bin/barbican'
      $barbican_wsgi_script_source    = "/usr/lib/python${pyver3}/site-packages/barbican/wsgi/api.py"
    }
    'Debian': {
      $common_package_name            = 'barbican-common'
      $api_service_name               = 'barbican-api'
      $api_package_name               = 'barbican-api'
      $worker_package_name            = 'barbican-worker'
      $worker_service_name            = 'barbican-worker'
      $keystone_listener_package_name = 'barbican-keystone-listener'
      $keystone_listener_service_name = 'barbican-keystone-listener'
      $retry_package_name             = undef
      $retry_service_name             = undef
      $barbican_wsgi_script_path      = '/usr/lib/cgi-bin/barbican'
      $barbican_wsgi_script_source    = '/usr/bin/barbican-wsgi-api'
    }
    default: {
      fail("Unsupported osfamily: ${facts['os']['family']}")
    }
  }
}
