unless Kernel.respond_to?(:require_relative)
  module Kernel
    def require_relative(path)
      require File.join(File.dirname(caller[0]), path.to_str)
    end
  end
end

require_relative '../../../../../scvmm/lib/puppet/provider/winrm'

Puppet::Type.type(:dnsserver_resourcerecord).provide(:default, :parent => Puppet::Provider::Winrm) do

  def exists?
    result = winrm_ps(exist_cmd)
    Puppet.debug("Get Response: #{result}")
    result.include? resource[:name]
  end

  def create
    winrm_ps(create_cmd)
  end

  def destroy
    command =  "Remove-DnsServerResourceRecord -ZoneName #{quote(resource[:zonename])} -Name #{quote(resource[:name])} "
    command.concat " -RRType #{quote(resource[:rrtype])} "
    command.concat " -Force" if resource[:force] == :true
    winrm_ps(command)
  end

  def exist_cmd
    command = "Get-DnsServerResourceRecord -zonename #{quote(resource[:zonename])}  | select hostname"
    Puppet.debug("Exists command: #{command}")
    command
  end

  def create_cmd
    command = "Add-DnsServerResourceRecord -ZoneName #{quote(resource[:zonename])} -Name #{quote(resource[:name])} -A -IPv4Address #{quote(resource[:ipaddress])}"
  end
end
