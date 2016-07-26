
#Deploy instance of vagrant locally

First you need to import to your environment the location of your een project
```
export EEN_SHARED_FOLDER_HOST=PATH_TO_YOUR_DRUPAL_PROJECT
export EEN_ELASTICSEARCH_SHARED_FOLDER_HOST=PATH_TO_YOUR_ELASTICSEARCH_PROJECT
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
- apache 2.4.7
- mysql 5.6.31
- php 5.6
- composer
- elasticsearch 2.3.1
- java 7
- node 0.10.25
- npm 1.3.10
- grunt-cli 1.2.0

Once the box booted, modify your hosts by adding this line:
```
192.168.10.10   een een-elasticsearch
```

Last part is to install the current version of your project in the box, for that follow those steps:
```
vagrant ssh
cd /var/www/een
make install
cd /var/www/een-elasticsearch
make install
```

Once the installation is complete you can go to this address on your navigator:
http://een/