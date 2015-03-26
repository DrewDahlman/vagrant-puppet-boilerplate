## Vagrant + Puppet + Rails
Will create the following environment
 - Ubuntu 12.04
 - nginx
 - unicorn
 - ruby
  - bundler
  - rails
 - postgres

## Requirements
 - Vagrant ( http://vagrantup.com )

## Things you should know
The intention of this package is to be used to provision a local vagrant environment that will run Nginx + Unicorn and support a rails app with postgres. You can modify many of these settings using the config.yml file found in the puppet directory.

## How to use
 - Create a new rails app `rails new myApp`
 - Copy over the Vagrantfile to the root of your application
 - Copy the puppet directory into your config directory in your app
 - Modify the `config/puppet/config.yml` to your needs

## Config.yml
 - `ruby_version`: The version of ruby to use
 - `application_name`: Name of your application
 - `application_path`: the path your app will live in. ( This will generally stay defaulted to vagrant )
 - `environment`: The environment to run in ( should generally stay as development )
 - `user`: This is the default user ( should generally stay as vagrant )

 - database: The application database settings
  - `database_name`: Name of your app development database
  - `user`: The user to use on your development database
  - `password`: The password for your development user

 - vm: The VM settings
  - `box`: The tyoe of box to use ( default is Ubunut 12.04 )
  - `box_url`: The source of the box to use 
  - `hostname`: The name you want to access your vagrantbox by ( see: hosts mod )
  - `memory`: The memory allocated to the VM ( default is 512 )
  - `cpus`: The CPUs allocated to the VM ( default 1 )
  - `chosen_provider`: The provider of the VM

  - Network: Network settings
   - `private_network`: The IP you want assigned to your box ( see: hosts )
   - forwarded_port:
    - ports:
     - `host`: Port from your machine to use connecting to the VM
     - `guest`: The port to connect to on the VM

  - `post_up_message`: Message to show post install and boot

  - Provision: The provisioning fun times
   - puppet:
    - `manifest_path`: the path to the puppet manifests
    - `manifest_file`: The file puppet should use to configure
    - `module_path`: The path to the puppet modules
    - `templates`: The path to templates to use for the application
    - `options`: Options to apply to puppet