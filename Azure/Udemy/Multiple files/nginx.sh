#cloud-config
package_upgrade: true
packages:
  - nginx
#  - multipass
runcmd:
  - cd /var/www
  - sudo chmod 757 html
#  - sudo chmod 757 /var/www/html
  - sudo su
  - sudo chmod 757 /home/