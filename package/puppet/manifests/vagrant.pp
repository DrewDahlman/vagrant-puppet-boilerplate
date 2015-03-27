# -*- mode: ruby -*-
# vi: set ft=ruby :

#--------------------------------------------------------------
#
#   Setup  
#
#--------------------------------------------------------------
# run apt-get update, but only if neccessary
exec { "apt-get update":
  command => "/usr/bin/apt-get update",
  onlyif => "/bin/sh -c '[ ! -f /tmp/apt.update ] || /usr/bin/find /etc/apt -cnewer /tmp/apt.update | /bin/grep . > /dev/null'"
}

# make sure apt-get update is run before
Exec["apt-get update"] -> Package <| |>

#--------------------------------------------------------------
#
#   Packages
#
#--------------------------------------------------------------
package { "vim": }
package { "libpq-dev": }
package { "nodejs": }


# update bashrc based on template
file { "bashrc": 
  path => "/home/${user}/.bashrc",
  content => template("bashrc.erb")
}

# create database.yml from template
file { "database.yml": 
  path => "/${user}/config/database.yml",
  content => template("database.erb")
}


#--------------------------------------------------------------
#
#   Ruby & rbenv
#
#--------------------------------------------------------------
rbenv::install { "${user}":
  group => "${user}",
  home  => "/home/${user}",
}

rbenv::compile { "${ruby_version}":
  user    => $user,
  home    => "/home/${user}",
  global  => true
}


#--------------------------------------------------------------
#
#   Postgres  
#
#--------------------------------------------------------------
class { "postgresql::server": }

# create the user (DEV)
postgresql::database_user { "${database_user}":
  password_hash => postgresql_password("${database_user}", "${database_password}"),
  createdb      => true,
  superuser     => true
}

#--------------------------------------------------------------
#
#   Nginx
#
#--------------------------------------------------------------
class nginx {
  
  package { "nginx":
    ensure => installed
  }

  file { "nginx_config":
    ensure    => "present",
    path      => "/etc/nginx/sites-available/default",
    content   => template("nginx_site.erb")
  }
}

#--------------------------------------------------------------
#
#   Unicorn  
#
#--------------------------------------------------------------  
class unicorn {
  package { 'unicorn':
    ensure   => 'installed',
    provider => 'gem'
  }

  file { "/etc/unicorn/":
    ensure => "directory"
  }

  file { "unicorn_config": 
    path => "/etc/unicorn/$application_name.rb",
    content => template("unicorn_conf.rb.erb")
  }

  file{"/etc/init.d/unicorn":
    content => template("unicorn_init.erb"),
    mode => "g=rwx,o=rx"
  }
}

#--------------------------------------------------------------
#
#   Required Gems  
#
#--------------------------------------------------------------
class gems {
  package { 'rake':
    ensure   => 'installed',
    provider => 'gem'
  }

  package { 'bundler':
    ensure   => 'installed',
    provider => 'gem'
  }
}

include gems
include nginx
include unicorn
