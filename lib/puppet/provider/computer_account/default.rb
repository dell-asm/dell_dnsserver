unless Kernel.respond_to?(:require_relative)
  module Kernel
    def require_relative(path)
      require File.join(File.dirname(caller[0]), path.to_str)
    end
  end
end

require_relative '../../../../../scvmm/lib/puppet/provider/winrm'

Puppet::Type.type(:computer_account).provide(:default, :parent => Puppet::Provider::Winrm) do

  def exists?
    @result = winrm_ps(exist_cmd)
    Puppet.debug("Get Response: #{@result}")
    !@result.empty?
  rescue Exception => e
    Puppet.debug("Command Execution failed: %s (%s)" % [e.to_s, e.class])
    return false
  end

  def create
    winrm_ps(create_cmd)
  end

  def destroy
    command = "dsrm.exe -q -noprompt -subtree #{@result}"
    winrm_ps(command)
  end

  def exist_cmd
    command = "dsquery computer -name #{quote(resource[:name])} "
    Puppet.debug("Exists command: #{command}")
    command
  end

  def create_cmd
    command = "dsadd computer #{quote(resource[:computer_path])}"
  end
end

