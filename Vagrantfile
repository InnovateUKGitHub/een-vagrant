# Test if the require variables are present

if ENV.has_key?('EEN_SHARED_FOLDER_HOST') === false
  puts "Please define EEN_SHARED_FOLDER_HOST in your Environment"
  exit
end

VAGRANTFILE_API_VERSION = "2"

EEN_BOX = 'ubuntu/trusty64'
EEN_BOX_NAME = 'een-dev'

EEN_IP_ADDRESS_HOST = '192.168.10.10'
EEN_RAM = '2048'
EEN_CPUS = 2

EEN_SHARED_FOLDER_GUEST = '/var/www/een'
EEN_SHARED_FOLDER_HOST = ENV['EEN_SHARED_FOLDER_HOST']

# When an api will be needed
#EEN_API_SHARED_FOLDER_GUEST = '/var/www/een-api'
#EEN_API_SHARED_FOLDER_HOST = ENV['EEN_API_SHARED_FOLDER_HOST']

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.define "lamp", primary: true do |lamp|
      # Specify the base box
      lamp.vm.box = EEN_BOX

      # static ip for local development
      lamp.vm.network "private_network", ip: EEN_IP_ADDRESS_HOST

      lamp.vm.synced_folder EEN_SHARED_FOLDER_HOST, EEN_SHARED_FOLDER_GUEST,
        :id => 'drupal',
        :nfs => true

      #lamp.vm.synced_folder EEN_API_SHARED_FOLDER_HOST, EEN_API_SHARED_FOLDER_GUEST,
      #  :id => 'api',
      #  :nfs => true

      # This uses uid and gid of the user that started vagrant.
      config.nfs.map_uid = Process.uid
      config.nfs.map_gid = Process.gid

      # Bindfs support to fix shared folder (NFS) permission issue on Mac
      if Vagrant.has_plugin?("vagrant-bindfs")
        config.bindfs.bind_folder EEN_SHARED_FOLDER_GUEST, EEN_SHARED_FOLDER_GUEST,
          perms: 'u=rwx:g=rwx:o=rwx'
        #config.bindfs.bind_folder EEN_API_SHARED_FOLDER_GUEST, EEN_API_SHARED_FOLDER_GUEST,
        #  perms: 'u=rwx:g=rwx:o=rwx'
      end

      lamp.vm.provider "virtualbox" do |v|
        v.name = EEN_BOX_NAME
        v.cpus = EEN_CPUS
        v.customize ["modifyvm", :id, "--paravirtprovider", "kvm"]
        v.customize ["modifyvm", :id, "--memory", EEN_RAM]
      end

      # Shell provisioning
      lamp.vm.provision :shell, :path => "./vagrant/bootstrap.sh"

      lamp.vm.post_up_message = <<EOF
*******************************************************************************
*                                                                             *
*                          EEN-LAMP virtual machine                           *
*                                                                             *
* This VM will bring up:                                                      *
*   - The Een Environment                                                     *
*   - Elastic Search                                                          *
*                                                                             *
* Commands:                                                                   *
*   # service apache2 status # displays the status of Apache                  *
*   # service mysql status # displays the status of MySQL                     *
*   # service elasticsearch status # display the status of Elasticsearch      *
*                                                                             *
* Configuration:                                                              *
*   MySQL root password - "password"                                          *
*                                                                             *
* Misc:                                                                       *
*   http://een/_plugin/head/ - Elasticsearch head                             *
*                                                                             *
* SSH:                                                                        *
*   vagrant ssh or vagrant ssh lamp                                           *
*                                                                             *
* Host Access:                                                                *
*   Please add this line to your hosts to access http://enn/                  *
*   192.168.10.10 een een-elasticsearch een-api                               *
*******************************************************************************
EOF
  end

end
