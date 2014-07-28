require 'vagrant-omnibus'
require 'vagrant-berkshelf'

box_date = "20140714"
box_url = "https://cloud-images.ubuntu.com/vagrant/trusty/#{box_date}/trusty-server-cloudimg-amd64-vagrant-disk1.box"

Vagrant.configure("2") do |config|
  config.vm.box       = "ubuntu-1404-#{box_date}"
  config.vm.hostname  = "fish-project"
  config.vm.box_url   = "#{box_url}"
  config.vm.network :private_network, ip: "33.33.33.50"
  config.vm.provider "virtualbox" do |v|
    v.gui = true
    v.memory = 1024
    v.cpus = 2
  end

  # The path to the Berksfile to use with Vagrant Berkshelf
  # config.berkshelf.berksfile_path = "./Berksfile"

  # Enabling the Berkshelf plugin. To enable this globally, add this configuration
  # option to your ~/.vagrant.d/Vagrantfile file
  config.berkshelf.enabled = true

  # An array of symbols representing groups of cookbook described in the Vagrantfile
  # to exclusively install and copy to Vagrant's shelf.
  # config.berkshelf.only = []

  # An array of symbols representing groups of cookbook described in the Vagrantfile
  # to skip installing and copying to Vagrant's shelf.
  # config.berkshelf.except = []

  config.omnibus.chef_version = :latest
  config.vm.provision "chef_solo" do |chef|

    chef.run_list = [
      "recipe[sencha_sdk::default]",
    ]
  end
end
