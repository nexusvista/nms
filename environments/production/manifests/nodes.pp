node 'puppetmaster' {
  file {'/tmp/info.txt':
    ensure => 'present',
    content => inline_template("Created by Puppet at <%= Time.now %>\n"),
  }
  class {'puppet': }
} 

node 'puppetclient.example.com' {

#  class {'puppet': }

  include role::base
  include role::lamp

  Class ['role::base'] -> Class ['role::lamp']

}
