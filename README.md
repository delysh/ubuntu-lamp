# Simple LAMP Vagrant box

Simple LAMP environment inside Vagrant box. Based on official `ubuntu/focal64` box.

## In the box:

- Ubuntu 20.04
- Apache 2.4
- MySQL 5.8
- PHP 8.0
- Node.js 12.x (with NPM)

### Additionally installed:

- phpMyAdmin
- Git
- Composer
- Yarn

## How to set up:

Assuming that VirtualBox (https://www.virtualbox.org/) and Vagrant (https://www.vagrantup.com/) are already installed on your computer.

1. Clone or download + unzip repository 
2. In your terminal go to the directory and type `vagrant up`
3. Wait (you may be prompt for system admin password)
4. Enjoy

## How to use:

After setup is finished, go to http://192.168.33.10/ in your browser. You should see the `phpinfo()` page.
`./www/`(or `/vagrant/www/` inside the box) is your "DocumentRoot". I recommend keeping your projects in the `projects/` folder and make symlinks from `www/` to `public_html` folder of your project. But it’s up to you.

`phpMyAdmin` is accessible at http://192.168.33.10/phpmyadmin/ Username is 'root', password - '12345678'

*tested on Mac OS X 12.1 (Monterey) with VirtualBox v6.1.30 and Vagrant 2.2.19
