# ofo-ansible
Ansible configurations for OFO VM setup

To run this **from* a new Jetstream2 VM in order to configure it (the standard OFO use-case):

```
sudo apt-get install ansible-core
ansible-pull ansible-pull -U https://github.com/open-forest-observatory/ofo-ansible -i inventory
```

If you want to specify a branch of the repo other than `main`, add `-C <branchname>`.

During development, the "pull" model can make iteration slow because you have to commit to the repo
before you can pull from the remote host. The repo is set up to additionally support the more
standard ansible approach (push) during development. To use it, you have to edit the `inventory`
file at the top level of the repo, and under the header `dev_testing`, add the public IP address(es)
of the VMs you want to apply the configuration to. Then run (from any machine that is allowed to SSH
into the VM):

```
ansible-playbook -i inventory playbook.yml
```
