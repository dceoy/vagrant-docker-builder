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

3.  Create a virtual machine.

    ```sh
    $ ./create_vm.sh
    ```

4.  Boot the virtual machine.

    ```sh
    $ vagrant up  # boot
    ```

    If you customize configurations such as memory, cpu, and http proxy, copy `example_config.yml` to `config.yml` and edit the contents.

    ```sh
    $ cp example_config.yml config.yml
    $ vi config.yml
    # => edit

    $ vagrant reload  # reboot
    ```

    Run `vagrant help` for more information about the usage of `vagrant`.

5.  Use the virtual machine.

    ```sh
    $ vagrant ssh # connect via ssh
    ```

    `share` is available as a synced directory (`/share` on the guest).
