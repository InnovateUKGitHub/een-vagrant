# Enterprise Europe Network (Alpha Version)

## Vagrant Project

This project has for goal to deploy on the developer machine a fully functional virtual machine

Requirements
------------

In order to use the virtual machine a few software are necessary:


- [Virtual box][1]
- [Vagrant][2]

If you are on a mac you need to install a vagrant plugin to fix nfs permissions
```
vagrant plugin install vagrant-bindfs
```

Installation
------------

On a terminal, move where you want to install the project and run:
```
git clone https://devops.innovateuk.org/code-repository/scm/een/een-vagrant.git
git checkout master
git checkout develop
```

Then run `vagrant up`. This command will download and install your virtual machine.
If it prompt you that you have not defined EEN_SHARED_FOLDER_HOST, please run the following command replacing the path:
```
export EEN_SHARED_FOLDER_HOST=PATH_TO_THE_ROOT_OF_YOUR_PROJECTS
```
It is best to add it globaly to your environment by adding the previous line to your .bashrc or .bash_profile
use `source ~/.bachrc` to reload your file to your current bash session

At this point you have time to get a nice coffee or tea as it can take up to 5 minutes.

Once the installation is complete you can log in to your virtual box using `vagrant ssh`

Here are the path of the projects you should have:
- webapp(drupal): /var/www/een
- service(zf3): /var/www/een-service

Those 2 folder have to be name "een" and "een-service" as the deployment scripts look for those name.

The box should be provide with:
- shared folder (nfs)
- apache 2.4.7
- mysql 5.6
- php 5.6
- composer
- elasticsearch 2.3.1
- java 7
- node 0.10.25
- npm 1.3.10
- gulp-cli 1.2.2

Once the box booted, modify your hosts by adding this line:
```
192.168.10.10   vagrant.een.co.uk vagrant.een-service.co.uk
```

Last part is to install the current version of your project in the box, for that follow those steps:
```
vagrant ssh
cd /var/www/een
make install
cd /var/www/een-service
make install
```

Once the installation is complete you can go to this address on your navigator:
http://vagrant.een.co.uk/

Links
-----

[Website][3] |
[Drupal Project][4] | 
[Service Project][5] | 
[Integration Project][6] | 
[Jira][7] | 
[Jenkins][8]

[1]: https://www.virtualbox.org/wiki/Downloads
[2]: https://www.vagrantup.com/downloads.html
[3]: https://een.int.aerian.com
[4]: https://devops.innovateuk.org/code-repository/projects/EEN/repos/een-webapp/browse?at=refs%2Fheads%2Fdevelop
[5]: https://devops.innovateuk.org/code-repository/projects/EEN/repos/een-service/browse?at=refs%2Fheads%2Fdevelop
[6]: https://devops.innovateuk.org/code-repository/projects/EEN/repos/een-integration-tests/browse?at=refs%2Fheads%2Fdevelop
[7]: https://devops.innovateuk.org/issue-tracking/secure/Dashboard.jspa
[8]: https://jenkins.aerian.com/view/een/
