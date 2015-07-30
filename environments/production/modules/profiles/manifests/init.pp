# == Class: profiles
#
# Full description of class profiles here.
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
#  class { 'profiles':
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
class profiles {


}

class profiles::php {

  $phpmysql = $osfamily ? {
    'redhat' => 'php-mysql',
    'debian' => 'php5-mysql',
    default  => 'php-mysql',
  }

  package { $phpmysql:
    ensure => 'present',
  }

  if $osfamily == 'redhat' {
    package { 'php-xml':
      ensure => 'present',
    }
  }

  file_line {'phptimezone':
    path  => '/etc/php.ini',
    line  => 'date.timezone = Europe/London',
    match => '^;date.timezone =$',
  }

  augeas { 'phptimezone':
    context => "/etc/php.ini",
    changes => "set date.timezone Europe/London",
  }



}

class profiles::admin_tools {

  $admin_tools = ['vim-enhanced', 'net-tools', 'telnet', 'git', 'wget']

  package {$admin_tools:
    ensure => 'installed',
  }

}

class profiles::disableipv6 {

  include ::sysctl

  ::sysctl::conf {

    "net.ipv6.conf.all.disable_ipv6": value     => 1;
    "net.ipv6.conf.default.disable_ipv6": value => 1;

  }

}

class profiles::ntp {

  class { '::ntp':
    servers => [ '0.uk.pool.ntp.org', '1.uk.pool.ntp.org', '2.uk.pool.ntp.org', '3.uk.pool.ntp.org' ],
  }

}

class profiles::timezone {
  #linux timezone

  class { '::timezone':
    timezone => 'Europe/London',
  }

}

class profiles::users {

  include users
  include users::local
  Users <| |>

}

class profiles::hosts {

  include ::hosts

}

class profiles::firewall {

  include ::firewall
  include ::my_fw
  include ::my_fw::pre
  include ::my_fw::post

}

class profiles::cacti {

  include ::cacti

}

class profiles::mysql {

  class { '::mysql::server':
    root_password => 'puppet',
  }

}

class profiles::apache {

  class { '::apache':
    docroot    => '/var/www/html',
    mpm_module => 'prefork',
  }

  class { '::apache::mod::php': }

}







