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

    result =~ /Returned records:.+@.+completed successfully/m
  rescue Exception => e
    Puppet.debug("Command Execution failed: %s (%s)" % [e.to_s, e.class])
    return false
  end

  def create
    winrm_ps(create_cmd)
  end

  def destroy
    command = "dnscmd /recorddelete #{quote(resource[:zonename])}"
    command.concat " #{quote(resource[:name])}"
    command.concat " #{quote(resource[:rrtype])}"
    command.concat " /f"
    winrm_ps(command)
  end

  def exist_cmd
    command = "dnscmd /enumrecords #{quote(resource[:zonename])} #{quote(resource[:name])} "
    Puppet.debug("Exists command: #{command}")
    command
  end

  def create_cmd
    command = "dnscmd /recordadd #{quote(resource[:zonename])}"
    command.concat " #{quote(resource[:name])}"
    command.concat " #{quote(resource[:rrtype])}"
    command.concat " #{quote(resource[:ipaddress])}"
  end
end
