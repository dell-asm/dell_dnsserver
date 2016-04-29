Puppet::Type.newtype(:computer_account) do
  ensurable

  newparam(:name, :namevar => true) do
    desc 'Computer account name'
  end

  newparam(:computer_name) do
    desc 'FQDN Computer account name'
  end
end

