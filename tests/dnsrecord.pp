import 'data.pp'

transport { 'winrm':
  server   => $data['server'],
  username => $data['username'],
  password => $data['password'],
}

dnsserver_resourcerecord { 'Comp10':
  ensure    => present,
  zonename  => 'dns.server',
  ipaddress  => 'Host_IP_Address',
  transport => Transport['winrm'],
}

