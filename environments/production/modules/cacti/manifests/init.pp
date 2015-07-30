# == Class: cacti
#
# Full description of class cacti here.
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
#  class { 'cacti':
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
class cacti {

  include ::firewall
  include ::mysql::server


  firewall { '0100 accept all http':
    proto  => 'tcp',
    port   => '80',
    action => 'accept',
  }

  file {'/var/www/html/cacti':
    ensure  => 'directory',
    require => Package['httpd'],
  }

  vcsrepo { '/var/www/html/cacti':
    ensure   => present,
    provider => git,
    source   => 'https://github.com/nexusvista/cacti.git',
    require  => File['/var/www/html/cacti'],
  }

  file { '/etc/cacti':
    ensure  => 'directory',
    before  => File['/etc/cacti/cacti.sql'],
  }


  file { '/etc/cacti/cacti.sql':
    mode    => 640,
    owner   => root,
    group   => root,
    source  => "puppet:///modules/cacti/cacti.sql",
  }


  mysql::db { 'cacti':
    user           => 'cactiuser',
    password       => 'cactiuser',
    host           => 'localhost',
    grant          => ['ALL'],
    sql            => '/etc/cacti/cacti.sql',
    import_timeout => 900,
    require        => File ['/etc/cacti/cacti.sql'],
  }

  if $osfamily == 'redhat' {
    package { [ 'php-snmp', 'php-ldap', 'net-snmp', 'net-snmp-utils', 'patch', 'rrdtool' ]:
#    package {  'cacti':
      ensure => 'present',
    }
  }

  cron { cactipoller:
    command => "/usr/bin/php /var/www/html/cacti/poller.php > /dev/null 2>&1",
    user    => root,
    minute  => '*/5'
  }


}
