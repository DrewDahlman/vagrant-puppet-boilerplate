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

## Why?
Working with teams it is always a good idea to create a VM to share between team members in order to keep the environment the same and avoid any issues that might arise based on a particular machines configuration.

Another perk of using a VM is that you can configure it to match your live environments as to avoid again issues that might arise during development / deployment. Using this provision method you ensure that all environments match and are on the same page which saves time and headaches in configuring.

If you aren't using VM's for development you should start.

## Things you should know
The intention of this package is to be used to provision a local vagrant environment that will run Nginx + Unicorn and support a rails app with postgres. You can modify many of these settings using the config.yml file found in the puppet directory.

The test application that is in this repo is a basic rails 4 app with Ruby 1.9.3. You can use any version of ruby or rails for your application, just be sure to update the config with the correct versions!

The default settings for the app use port 80 which allows you to access your VM without having to use a specific port such as 3000. You can modify this in the config file.

## Let 'er rip
If you want to see the package in action just cd into the testApp directory and run `vagrant up` and watch the magic happen.

## How to use
 - Create a new rails app `rails new myApp`
 - Copy over the Vagrantfile to the root of your application
 - Copy the puppet directory into your config directory in your app
 - Modify the `config/puppet/config.yml` to your needs
 - run `vagrant up`
 - On first run puppet will run bundle install as well as rake on your databases
 - On first run once the provision is complete run `vagrant reload` ( this starts unicorn )
 - Once complete open your browser and go to what ever you set as the hostname.

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

## Neat things
You will notice in the Vagrantfile the mention of shell scripts - 
<pre>
  #--------------------------------------------------------------
  #
  #   Starup Scripts
  #
  #--------------------------------------------------------------
  config.vm.provision :shell, :inline => "sudo apt-get update --fix-missing"
  config.vm.provision :shell, run: 'once' do |s|
    s.path = 'config/puppet/shell/bundler.sh'
    s.args = ['startup-once']
  end

  config.vm.provision :shell, run: 'once' do |s|
    s.path = 'config/puppet/shell/rake.sh'
    s.args = ['startup-once']
  end

  config.vm.provision :shell, run: 'always' do |s|
    s.path = 'config/puppet/shell/startup.sh'
    s.args = ['startup-always']
  end
</pre>

These are shell scripts that are run on initial setup as well as on every startup. You will find them in the `config/puppet/shell` directory. You can add to them if you would like to take extra actions on your box.

On first run once vagrant has completed it's setup and puppet has provisioned the shell scripts bundler and rake will execute. They will run a bundle install as well as rake on your databases. This ensures that everything is in place for you to quickly get started.

## Hosts
You can add a new record to your hosts file to allow you to hit a custom domain for your application.

 - edit your hosts file `/etc/hosts`
 - in the first column add the IP you have in your `config.yml` file
 - in the second column add the hostname from your `config.yml` file

example:
<pre>
##
# Host Database
#
# localhost is used to configure the loopback interface
# when the system is booting.  Do not change this entry.
##

127.0.0.1       localhost
255.255.255.255 broadcasthost
::1             localhost
192.168.56.101  mytestapp.dev
</pre>

## Uh oh!
If something seems to not be working always remember:
 - `vagrant reload` - will reload the environment you know everything is good if you see the output "Best provision out, that's what everyone's been sayin'"
 - `vagrant provision` - Will reprovision the box
 - `vagrant destroy` - Will toast the box and let you start over ( sometimes you just have to )

Most often running vagrant reload will fix most issues. You might need to relaod your environment, that will do it.