$site = 'htmlpad.org'
$rootDir = '/home/atul/htmlpad'
$apacheDir = '/etc/apache2'
$varDir = "/var/$site"
$wsgiDir = "$varDir/wsgi-scripts"
$staticFilesDir = "$varDir/static-files"

package { 'libapache2-mod-wsgi':
  ensure => present,
  before => File["$apacheDir/sites-available/$site"],
}

service { 'apache2':
  ensure => running,
  enable => true,
  hasrestart => true,
  hasstatus => true,
  subscribe => File["$apacheDir/sites-available/$site"],
}

file { "$apacheDir/sites-available/$site":
  ensure => file,
  owner => 'root',
  group => 'root',
  content => template("$rootDir/$site.erb"),
}

file { "$apacheDir/sites-enabled/001-$site":
  ensure => link,
  target => "$apacheDir/sites-available/$site"
}

file { "$varDir":
  ensure => link,
  target => "$rootDir/$site"
}