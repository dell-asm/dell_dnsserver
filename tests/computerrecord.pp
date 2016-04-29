import 'data.pp'

transport { 'winrm':
  server   => $data['server'],
  username => $data['username'],
  password => $data['password'],
}

computer_account { 'Comp10':
  ensure    => absent,
  transport => Transport['winrm'],
}

