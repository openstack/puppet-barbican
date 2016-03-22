Puppet::Type.type(:barbican_config).provide(
  :openstackconfig,
  :parent => Puppet::Type.type(:openstack_config).provider(:ruby)
) do

  def file_path
    '/etc/barbican/barbican.conf'
  end

end
