require 'yaml'

dir          = File.dirname(File.expand_path(__FILE__))
configValues = YAML.load_file("#{dir}/config/puppet/config.yaml")
data         = configValues['vagrantfile-local']
Vagrant.require_version '>= 1.6.0'

Vagrant.configure('2') do |config|

  #--------------------------------------------------------------
  #
  #   Config the box
  #
  #--------------------------------------------------------------
  config.vm.box     = "#{data['vm']['box']}"
  config.vm.box_url = "#{data['vm']['box_url']}"

  if data['vm']['hostname'].to_s.strip.length != 0
    config.vm.hostname = "#{data['vm']['hostname']}"
  end

  config.vm.network 'private_network', ip: data['vm']['network']['private_network']
  data['vm']['network']['forwarded_port'].each do |i, port|
    if port['guest'] != '' && port['host'] != ''
      config.vm.network :forwarded_port, guest: port['guest'].to_i, host: port['host'].to_i
    end
  end

  if !data['vm']['post_up_message'].nil?
    config.vm.post_up_message = "#{data['vm']['post_up_message']}"
  end

  #--------------------------------------------------------------
  #
  #   Puppet Provision
  #
  #--------------------------------------------------------------
  if !data['vm']['provision']['puppet'].nil?
    config.vm.provision :puppet do |puppet|
      
      puppet.facter = {
        'user'                 => "#{data['user']}",
        'environment'          => "#{data['environment']}",
        'application_name'     => "#{data['application_name']}",
        'application_path'     => "#{data['application_path']}",
        'database_name'        => "#{data['database']['database_name']}",
        'database_user'        => "#{data['database']['user']}",
        'database_password'    => "#{data['database']['password']}",
        'ruby_version'         => "#{data['ruby_version']}",
        'server_name'          => "#{data['vm']['hostname']}",
        'port'                 => "#{data['vm']['network']['forwarded_port']['ports']['guest']}"
      }

      puppet.manifests_path = data['vm']['provision']['puppet']['manifests_path']
      puppet.manifest_file = data['vm']['provision']['puppet']['manifest_file']
      puppet.module_path = data['vm']['provision']['puppet']['module_path']
      puppet.options = Array.new
      data['vm']['provision']['puppet']['options'].each do |opt|
        puppet.options << opt
      end
    end
  end

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
end