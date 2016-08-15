vbox-docker-builder
===================

Virtual machine builder using Vagrant and VirtualBox for use of Docker

Host: Mac OS X or Linux  
Guest: Ubuntu 16.04 LTS (Xenial Xerus)

Setup
-----

1.  Install [Vagrant](https://www.vagrantup.com/) and [VirtualBox](https://www.virtualbox.org/).

2.  Check out the repository.

    ```sh
    $ git clone https://github.com/dceoy/vbox-docker-builder.git ~/vm
    $ cd ~/vm
    ```

    If you use an HTTP proxy, set values at `config.yml` before creating a virtual machine.  
    `config.yml` can be used to customize configurations.

    ```sh
    $ cp example_config.yml config.yml
    $ vi config.yml # => edit
    ```

3.  Create a virtual machine.

    ```sh
    $ ./create_vm.sh

    # if you use `sudo` for `vagrant`:
    $ ./create_vm.sh --sudo
    ```

    Run `./create_vm.sh --help` for the usage on a command.

4.  Boot the virtual machine.

    ```sh
    $ vagrant up  # boot
    $ vagrant ssh # connect via ssh

    # if you use `sudo` for `vagrant`:
    $ sudo -E vagrant up
    $ sudo -E vagrant ssh
    ```

    See [the documents for Vagrant](https://www.vagrantup.com/docs/cli/) for more information about `vagrant` command.
