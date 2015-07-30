# == Class: users
#
# Full description of class users here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'users':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2015 Your name here, unless otherwise noted.
#
define users ( $uid, $key, $key_type, $home="/home/$title", $shell='/bin/bash' ) {

  $uname     = $title
  $gname     = $uname
  $gid       = $uid
  
  group { "$gname":
    allowdupe  => false,
    ensure     => present,
    name       => "$gname",
    gid        => "$gid",
  }

  user { "$uname":
    ensure     => present,
    allowdupe  => false,
    managehome => true,
    name       => "$uname",
    uid        => "$uid",
    gid        => "$gid",
    shell      => "$shell",
    home       => "$home",
    require    => Group["$gname"],
  }

  ssh_authorized_key { "$uname":
  ensure     => present,
  key        => "$key",
  name       => "$uname@comm.so",
  type       => "$key_type",
  user       => "$uname",
  require    => User["$uname"],
  }
}

