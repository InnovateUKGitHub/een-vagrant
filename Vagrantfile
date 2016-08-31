# Test if the require variables are present

if ENV.has_key?('EEN_WEB_APP_SHARED_FOLDER_HOST') === false
  puts "Please define EEN_WEB_APP_SHARED_FOLDER_HOST in your Environment"
  exit
end

if ENV.has_key?('EEN_SERVICE_SHARED_FOLDER_HOST') === false
  puts "Please define EEN_SERVICE_SHARED_FOLDER_HOST in your Environment"
  exit
end

VAGRANTFILE_API_VERSION = "2"

EEN_BOX = 'ubuntu/trusty64'
EEN_BOX_NAME = 'een-dev'

EEN_IP_ADDRESS_HOST = '192.168.10.10'
EEN_RAM = '2048'
EEN_CPUS = 2

EEN_WEB_APP_SHARED_FOLDER_GUEST = '/var/www/een'
EEN_WEB_APP_SHARED_FOLDER_HOST = ENV['EEN_WEB_APP_SHARED_FOLDER_HOST']

EEN_SERVICE_SHARED_FOLDER_GUEST = '/var/www/een-service'
EEN_SERVICE_SHARED_FOLDER_HOST = ENV['EEN_SERVICE_SHARED_FOLDER_HOST']

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.define "lamp", primary: true do |lamp|
      # Specify the base box
      lamp.vm.box = EEN_BOX

      # static ip for local development
      lamp.vm.network "private_network", ip: EEN_IP_ADDRESS_HOST

      lamp.vm.synced_folder EEN_WEB_APP_SHARED_FOLDER_HOST, EEN_WEB_APP_SHARED_FOLDER_GUEST,
        :id => 'drupal',
        :nfs => true,
        :mount_options => ['actimeo=2']

      lamp.vm.synced_folder EEN_SERVICE_SHARED_FOLDER_HOST, EEN_SERVICE_SHARED_FOLDER_GUEST,
        :id => 'api',
        :nfs => true,
        :mount_options => ['actimeo=2']

      # This uses uid and gid of the user that started vagrant.
      config.nfs.map_uid = Process.uid
      config.nfs.map_gid = Process.gid

      # Bindfs support to fix shared folder (NFS) permission issue on Mac
      if Vagrant.has_plugin?("vagrant-bindfs")
        config.bindfs.bind_folder EEN_WEB_APP_SHARED_FOLDER_GUEST, EEN_WEB_APP_SHARED_FOLDER_GUEST,
          perms: 'u=rwx:g=rwx:o=rwx',
          owner: 'vagrant',
          group: 'vagrant'
        config.bindfs.bind_folder EEN_SERVICE_SHARED_FOLDER_GUEST, EEN_SERVICE_SHARED_FOLDER_GUEST,
          perms: 'u=rwx:g=rwx:o=rwx',
          owner: 'vagrant',
          group: 'vagrant'
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
*******************************************************************************************
*                                                                                         *
*                          EEN-LAMP virtual machine                                       *
*                                                                                         *
* This VM will bring up:                                                                  *
*   - The Een Environment                                                                 *
*   - Elastic Search                                                                      *
*                                                                                         *
* Commands:                                                                               *
*   # service apache2 status # displays the status of Apache                              *
*   # service mysql status # displays the status of MySQL                                 *
*   # service elasticsearch status # display the status of Elasticsearch                  *
*                                                                                         *
* Configuration:                                                                          *
*   MySQL root password - "password"                                                      *
*                                                                                         *
* Misc:                                                                                   *
*   http://een:9200/_plugin/head/ - Elasticsearch head                                    *
*                                                                                         *
* SSH:                                                                                    *
*   vagrant ssh or vagrant ssh lamp                                                       *
*                                                                                         *
* Host Access:                                                                            *
*   Please add this line to your hosts to access http://enn/                              *
*   192.168.10.10 vagrant.een.co.uk vagrant.een-service.co.uk                             *
*******************************************************************************************
EOF
  end

end
