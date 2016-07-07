
#Deploy instance of vagrant locally

First you need to import to your environment the location of your een project
```
export shared_folder=PATH_TO_YOUR_PROJECT
```

If you are on a mac you need to install a vagrant plugin to fix nfs permissions
```
vagrant plugin install vagrant-bindfs
```

It is best to add it globaly to your environment by adding the previous line to your .bashrc or .bash_profile
use `source ~/.bachrc` to reload your file to your current bash session

Once your environment correct (you can verify by using echo $shared_folder), you can up the box with `vagrant up`

This will provision the box with all the necessary installation.
The box should be provide with:
- shared folder (nfs)
- apache2
- mysql 5.5.44
- php 5.5.9
- composer
- elasticsearch 2.3.1
- java 7

Once the box booted, modify your hosts by adding this line:
```
192.168.10.10   een
```

Last part is to install the current version of your project in the box, for that follow those steps:
```
vagrant ssh
cd /var/www/een
make install
```

Once the installation is complete you can go to this address on your navigator:
http://een/