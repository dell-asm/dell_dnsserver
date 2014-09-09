# dell_dnsserver #

Puppet module for adding / removing Host(A) record to/from DNS Server

## Usage

### Overview

The dnsserver module manages resource on DNS Server via [Windows Remote Management (WinRM)](http://msdn.microsoft.com/en-us/library/aa384426.aspx). The transport module pattern is used to communicate with the SCVMM server (similar to VMware vCenter).
This module shares the winrm transport with https://github.com/dell-asm/puppet-scvmm.git

```
+-----------+         +---------------+ 
|           |  WinRM  |               | 
| Appliance | +-----> |  DNS Server   | 
|           |         |               |
+-----------+         +---------+----- 
```

### WinRM

The transport connection setting depends on the DNS Server host configuration. The default configuration is basic auth which requires the following WinRM settings. This is adjustable, see [WinRM gem](https://github.com/WinRb/WinRM) for additional documentation.

```powershell
winrm set winrm/config/client/auth '@{Basic="true"}'
winrm set winrm/config/service/auth '@{Basic="true"}'
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
```

WinRM processes are limited to 150 MB or memory by default. We need to increase this to 1024 to avoid out of memory errors:
```powershell
winrm set winrm/config/winrs '@{MaxMemoryPerShellMB=1024}'
```

For Windows 2008
```powershell
winrm quickconfig
```

There is a known issue with WMF 3.0. If the MaxMemoryPerShellMB configuration appears to be ignored, please see [KB2842230](http://support.microsoft.com/kb/2842230). The hotfix for Windows 8/Windows 2012 x64 is available at the following [link](http://hotfixv4.microsoft.com/Windows%208%20RTM/nosp/Fix452763/9200/free/463941_intl_x64_zip.exe).

### Transport

The transport resource specifies the connectivity information for the SCVMM server:
```puppet
$username = 'administrator'
$password = 'password'

transport { 'winrm':
  server   => '192.168.1.1',
  username => $username,
  password => $password,
}
```

The transport resource option parameter allows adjustment of WinRM connectivity type and connectivity options such as port (for more details see WinRM transport implementation):
```puppet
transport { 'winrm':
  server   => '192.168.1.1',
  username => $username,
  password => $password,
  options  => {
    'connectivity' => 'ssl',
    'port'         => '5986',
  }
}
```

### DNS Server Resources

Once connectivity is specified the dnssrver module can manage the following resource on the DNS server:
```puppet
dnsserver_resourcerecord { 'Comp1':
  ensure    => present,
  zonename  => 'dns.server',
  ipaddress  => 'Host_IP_Address',
  transport => Transport['winrm'],
}

```


