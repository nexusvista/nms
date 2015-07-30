class my_fw::pre {
  Firewall {
    require => undef,
  }
   # Default firewall rules
  firewall { '0000 accept all icmp':
    proto  => 'icmp',
    action => 'accept',
  }->
  firewall { '0001 accept all to lo interface':
    proto   => 'all',
    iniface => 'lo',
    action  => 'accept',
  }->
  firewall { '0002 reject local traffic not on loopback interface':
    iniface     => '! lo',
    proto       => 'all',
    destination => '127.0.0.1/8',
    action      => 'reject',
  }->
  firewall { '0003 accept related established rules':
    proto  => 'all',
    state  => ['RELATED', 'ESTABLISHED'],
    action => 'accept',
  }->
  firewall { '0010 accept puppet communication':
    proto  => 'tcp',
    port   => '8140',
    action => 'accept',
  }
}
