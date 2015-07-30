# == Class: puppet
#
# Full description of class puppet here.
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
#  class { 'puppet':
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
class puppet {

  $admin_tools = ['vim-enhanced','net-tools']
  $admin_file  = ['/var/www/html/ipplan','/var/www/html/phpmyadmin']

  package{ $admin_tools:
    ensure => 'installed',
  }

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

  class { '::apache':
    docroot    => '/var/www/html',
    mpm_module => 'prefork',
    subscribe  => Package[$phpmysql],
#    before     => File[$admin_file],
  }
  
  class { '::apache::mod::php': }

  class { '::mysql::server':
    root_password => 'puppet',
  }

  file { '/var/www/html/ipplan':
    source  => 'puppet:///modules/puppet/ipplan',
    recurse => true,
  }

#  file { '/var/www/html/phpmyadmin':
#    source  => 'puppet:///modules/puppet/phpmyadmin',
#    recurse => true,
#  }
  
#  class { '::splunk::params':
#    version      => '6.2.3',
#    build        => '264376',
#    src_root     => "puppet:///modules/splunk",
#  }

#  class { '::splunk': }

#  class { 'rancid': }

}
