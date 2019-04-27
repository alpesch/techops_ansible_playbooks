This repo contains Ansible playbooks. Currently, this focuses on deployment.

* [Requirements on remote nodes](#requirements-on-remote-nodes)
* [How to install and setup Ansible](#how-to-install-and-setup-ansible)
  * [Ansible](#ansible)
  * [Homebrew & sshpass](#homebrew--sshpass)
* [Working with and running an Ansible Playbook](#working-with-and-running-an-ansible-playbook)
  * [Ansible Config file](#ansible-config-file)
  * [Hosts file](#hosts-file)
  * [Running Ansible](#running-ansible)
  * [aws turnup playbook](#aws_turnup_playbookyaml)
  * [Example](#example)

# Requirements on remote nodes
There are 3 requirements for running Ansible on remote nodes:
* The nodes must be reachable via SSH
* The nodes must have Python installed
* Because some tasks that Ansible completes require sudo privileges, we want to allow the ubuntu\
  user to be allowed to run sudo without prompting for a password. To do this, log into each\
  remote node and perform the following 3 steps:
  * Run `$ sudo visudo`
  * Add the following line to the bottom of the file: `ubuntu ALL=(ALL) NOPASSWD: ALL`
  * Save and exit

# How to install and setup Ansible
## Ansible
* `$ sudo pip install ansible`
  * NOTE - If the remote nodes only have Python 3 installed, use `$ sudo pip3 install ansible`\
    Don't have pip3? It can be installed with Homebrew (next session below) with `$ brew install pip3`
* `$ git clone git@github.com:alpesch/techops_ansible_playbooks.git`
* Modify hosts file with the public IP addresses in AWS according to your deployment (master node IP(s) under **[master]**, 
  worker node IP(s) under **[workers]**)
  * NOTE - These should be the IP addresses that are reachable from your Mac via SSH.

* Run the deployment_helper.sh script. This places the correct packages in /tmp/packages,
  where ansible expects them to be.
## Homebrew & sshpass
Homebrew is used to install a needed package for SSH tasks used by Ansible called sshpass.
* `$ ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`
* Install the SSH package needed by Ansible. Because Brew doesn't directly support this library,
  we have to install it from a git repo using brew.
  * `$ brew install https://raw.githubusercontent.com/kadwanev/bigboybrew/master/Library/Formula/sshpass.rb`

# Working with and running an Ansible playbook
## Ansible Config file
* [Ansible can be configured](https://docs.ansible.com/ansible/latest/installation_guide/intro_configuration.html#) using one of 2 ansible.cfg files:
  * /etc/ansible/ansible.cfg
  * ~/.ansible.cfg
  * The last file is the user config file, which 
    overrides the default config if present.
  * The current ansible.cfg file sets the ansible user to ubuntu
    to take advantage of passwordless SSH in AWS.
## Hosts file
* This file is not the same as /etc/hosts. It lives in /etc/ansible/hosts
* [Additional configuration settings](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html) can be made using this file.
## Running Ansible
* Ansible can be run with one task in mind, or many tasks. Single tasks can
  be accomplished on the commandline. 
* For multi-tasked jobs, [playbooks can be used](https://docs.ansible.com/ansible/latest/user_guide/playbooks.html)
* To use a playbook, the syntax is `$ ansible-playbook <playbook filename>`
* Want to see more output? Use the `-v` flag.
* Be sure to add your AWS private key to your ssh-agent before running Ansible.
  * Example - `$ ssh-add ~/.ssh/id_rsa`
  * Not sure if you've already added it? You can check what keys your agent is aware of with `$ ssh-add -L`
* In general, the colored output represents the following:
  * Red - Ansible may not have completed all or parts of a task successfully.
  * Yellow - Informational text, usually indicating something on the target system has been changed by Ansible.
  * Green - Ansible completed all or part of a task successfully. Yay!
## aws_turnup_playbook.yaml
This playbook will perform the following tasks:
* Master node
  * Setup support user
  * Add support user to sudoers
  * generate SSH keypair
  * Create /pipedream/provision/release folders
  * Copy down .deb packages and move them to the right place:
    * Conda (Ansible installs this package), Deeploy, Pipedream, Systems
* Worker node(s)
  * Setup support user
  * Add support user to sudoers
  * Create .ssh folder under /home/support
  * Copy kepair from master to worker node(s)
  * Create /pipedream/provision/release folders
  * Copy down .deb packages and move them to the right place:
    * Conda (Ansible installs this package), Deeploy, Pipedream, Systems
## Example
`$ ansible-playbook aws_turnup_playbook.yaml`
* TL;DR of how Ansible uses the files discussed above:
  * Reads in the [playbook](https://docs.ansible.com/ansible/latest/user_guide/playbooks.html) - aws_turnup_playbook.yaml
  * Configures itself according to [/etc/ansible/ansible.cfg](https://docs.ansible.com/ansible/latest/installation_guide/intro_configuration.html#)
  * Executes against hosts found in [/etc/ansible/hosts](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html)

  
