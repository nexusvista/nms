class my_fw::post {
  firewall { '9999 drop all':
    proto  => 'all',
    action => 'drop',
    before => undef,
  }
}
