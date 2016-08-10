vagrant-docker-vm
=================

Vagrantfile and its helper script for use of Docker on Vagrant and VirtualBox

Host: Mac OS X or Linux  
Guest: Ubuntu 16.04 LTS (Xenial Xerus)

Setup
-----

1.  Install [Vagrant](https://www.vagrantup.com/) and [VirtualBox](https://www.virtualbox.org/).

2.  Check out the repository.

    ```sh
    $ git clone https://github.com/dceoy/vagrant-docker-vm.git ~/vm
    $ cd ~/vm
    ```

    If you use an HTTP proxy, set values at `config.yml` before creating a virtual machine.

    ```sh
    $ cp example_config.yml config.yml
    $ vi config.yml # => edit
    ```

3.  Create a virtual machine.

    ```sh
    $ ./create_vm.sh
    ```

    `create_vm.sh` copy `example_config.yml` to `config.yml` if `config.yml` does not exist.  
    `config.yml` can be used to customize configurations.

4.  Boot the virtual machine.

    ```sh
    $ vagrant up  # boot
    $ vagrant ssh # connect via ssh
    ```

    Run `vagrant help` for more information about the usage of `vagrant`.
