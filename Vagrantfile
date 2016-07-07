VAGRANTFILE_API_VERSION = "2"

if ENV['shared_folder']
  SHARED_FOLDER = ENV['shared_folder']
else
  SHARED_FOLDER = "."
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.define "lamp", primary: true do |lamp|
      # Specify the base box
      lamp.vm.box = "chrislentz/trusty64-lamp"

      # static ip for local development
      lamp.vm.network "private_network", ip: "192.168.10.10"

      lamp.vm.synced_folder SHARED_FOLDER, '/var/www/een',
        :nfs => true,
        :mount_option => ["actimeo=1"]

      # This uses uid and gid of the user that started vagrant.
      config.nfs.map_uid = Process.uid
      config.nfs.map_gid = Process.gid

      # Bindfs support to fix shared folder (NFS) permission issue on Mac
      if Vagrant.has_plugin?("vagrant-bindfs")
        config.bindfs.bind_folder "/var/www/een", "/var/www/een",
          perms: "u=rwx:g=rwx:o=rwx"
      end

      lamp.vm.provider "virtualbox" do |v|
        v.name = "een-dev"
        v.cpus = 2
        v.customize ["modifyvm", :id, "--paravirtprovider", "kvm"]
        v.customize ["modifyvm", :id, "--memory", "2048"]
        v.customize ["guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-start"]
        v.customize ["guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-on-restore", 1]
        v.customize ["guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 10000]
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
*   192.168.10.10 een                                                         *
*******************************************************************************
EOF
  end

end
