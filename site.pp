$templates = "${home}/bergerac/templates"

$bergerac_user = $user

# Apache configs
$apache_port = 80
$apache_port_ssl = 443
$apache_sites_dir = "${home}/Sites"
$apache_config_dir = '/etc/apache2'
$apache_log_dir = '/private/var/log/apache2'
$apache_cert = "${home}/bergerac/data/ssl/apache.crt"
$apache_cert_key = "${home}/bergerac/data/ssl/apache.key"

file { '/etc/apache2/extra/httpd-vhosts.conf':
  content => template("${templates}/apache/httpd-vhosts.conf.erb"),
  owner   => root,
  group   => wheel
}
file { '/etc/apache2/extra/httpd-ssl.conf':
  content => template("${templates}/apache/httpd-ssl.conf.erb"),
  owner   => root,
  group   => wheel
}
file { '/etc/apache2/httpd.conf':
  content => template("${templates}/apache/httpd.conf.erb"),
  owner   => root,
  group   => wheel
}

# Dnsmasq configs
$dnsmasq_host = '127.0.0.1'
$dnsmasq_tld = 'dev'

file { '/usr/local/etc/dnsmasq.conf':
  content => template("${templates}/dnsmasq/dnsmasq.conf.erb"),
  owner   => root,
  group   => wheel
}
file { '/Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist':
  content => template("${templates}/dnsmasq/homebrew.mxcl.dnsmasq.plist.erb"),
  owner   => root,
  group   => wheel
}
file { '/etc/resolver':
  ensure => 'directory',
  owner   => root,
  group   => wheel
}
file { '/etc/resolver/dev':
  content => 'nameserver 127.0.0.1',
  owner   => root,
  group   => wheel,
  require => File['/etc/resolver']
}
service { 'homebrew.mxcl.dnsmasq':
  ensure  => 'running',
  require => File['/Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist']
}

$php_mysql_socket = '/private/tmp/mysql.sock'

file { '/usr/local/etc/php/5.5/php.ini':
  content => template("${templates}/php/php.ini.erb")
}

file { '/Library/LaunchDaemons/homebrew.mxcl.mysql.plist':
  content => template("${templates}/mysql/homebrew.mxcl.mysql.plist.erb")
}

service { 'homebrew.mxcl.mysql':
  ensure => 'running',
  require => File['/Library/LaunchDaemons/homebrew.mxcl.mysql.plist']
}
