This repo contains Ansible playbooks. Currently, this focuses on deployment.

# How to use Ansible

* `sudo pip install ansible`
* `git clone git@github.com:alpesch/techops_ansible_playbooks.git`
* Modify hosts file according to your deployment (master node under master, 
  worker nodes under workers)
* Run the deployment_helper.sh script. This places the correct packages in /tmp/packages,
  where ansible expects them to be.
* run `ansible-playbook aws_turnup_playbook.yaml`

# aws_turnup_playbook.yaml
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
