
class mysql::client {
  package { 'mysql-client':
    ensure  => installed,
  }
}


class mysql::server {
  include mysql::client

  package { 'mysql-server':
    ensure  => installed,
  }

  service { 'mysql':
    enable => true,
    ensure => running, 
    hasstatus => true,
    require => [Package['mysql-server'], File['/etc/mysql/my.cnf']],
  }
  
  exec { "set-mysql-password":
      unless => "mysqladmin -uroot -p$mysql_password status",
      path => ["/bin", "/usr/bin"],
      command => "mysqladmin -uroot password $mysql_password",
      require => Service["mysql"],
  }
  
  file { '/etc/mysql/my.cnf':
     ensure => present,
     mode   => 644,
     owner  => 'root',
     source => 'puppet:///modules/mysql/my.cnf',
     require => Package['mysql-server'], 
   }

}