Puppet::Type.type(:barbican_api_uwsgi_config).provide(
  :ini_setting,
  :parent => Puppet::Type.type(:openstack_config).provider(:ini_setting)
) do
  def self.file_path
    '/etc/barbican/barbican-api-uwsgi.ini'
  end
end
