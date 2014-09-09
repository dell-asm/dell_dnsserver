Puppet::Type.newtype(:dnsserver_resourcerecord) do
  ensurable

  newparam(:name, :namevar => true) do
    desc 'DNS Record Name'
  end

  newparam(:zonename) do
    desc 'zone name where record needs be added / removed'
  end

  newparam(:force) do
    desc 'Record needs to be added / removed with force flag'
    newvalues(:true,:false)
    defaultto(:true)
  end
  
  newparam(:ipaddress) do
    desc 'IP Address needs to be assigned to the DNS record'
  end
  
  newparam(:rrtype) do
    desc 'record type'
    defaultto 'A'
  end
    
end
