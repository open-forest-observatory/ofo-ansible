# ofo-ansible

This repo defines a comprehensive configuration for the OFO dev image on JS2 that can be applied via a single command using Ansible.

You can apply the configuration via "push" (the traditional Ansible method), where you run ansible on a local machine and instruct it to configure a remote machine, or by "pull", where you install Ansible on the remote machine and have the machine configure itself.

## Applying via push from a local machine

This is the smoothest way to apply the configuration, though it requires you:
- have Ansible installed locally (on Linux, `sudo apt install ansible`)
- have this repo cloned locally and have switched to the repo's root folder

If the IP address of the instance to be configured is different from the one listed in the repo's top-level `inventory` file (under the `[remote]` heading), edit the file and update the IP address to the current public IP address of the instance to be configured.

Then run (from any machine that is allowed to SSH into the VM) `ansible-playbook -i inventory playbook.yml`.


## Applying via pull from the machine to be configured

SSH into the machine to be configured, then run:

```
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt-get install ansible-core -y
ansible-galaxy collection install ansible.posix
ansible-pull -U https://github.com/open-forest-observatory/ofo-ansible -i inventory
```

If you want to specify a branch of the repo other than `main`, add `-C <branchname>`.

## Potential issues/troubleshooting

If the ansible configuration process hangs (no updates on screen for > 1 minute), you may need to press **Ctrl-C** to cancel it, then **up arrow** to recall your last command, then **Enter** to start it again. It should take about 15 minutes total. When it finishes, it will display a **PLAY RECAP** and take you back to your command prompt.

On a blank JS2 featured image, the default SSH timeout may be so short that the SSH session dies in the middle of a configuration run. (This might only apply to the "pull" method of configuration.) If this happens, you'll need to reconnect the SSH session and rerun the ansible command. One of the first configurations that is run is to extend the SSH timeout, so the second time you run it, you should not encounter the same problem. (The configuration is indempotent and generally skips steps that have already been completed, so it's OK if parts of it are applied more than once.)


If you want to specifically (and only) set up an encrypted private folder on an already-configured ofo dev VM:
```
ansible-pull -U https://github.com/open-forest-observatory/ofo-ansible -i inventory -e RUN_MAIN=no -e RUN_PRIVATE=yes -e CREDS_PASSWORD=<password>
```
but replacing `<password>` with a password you will remember to decrypt your private folder. For details on the private folder usage, see [OFO internal documentation](https://docs.openforestobservatory.org/internal-docs/jetstream/#private-encrypted-folder).

During development, the "pull" model can make iteration slow because you have to commit and push to the repo
before you can pull from the remote host. The repo is set up to additionally support the more
traditional ansible approach (push) during development. To use it, you have to edit the `inventory`
file at the top level of the repo, and under the header `remote`, add the public IP address(es)
of the VMs you want to apply the configuration to. Then run (from any machine that is allowed to SSH
into the VM):

```
ansible-playbook -i inventory playbook.yml
```

## Setting up an encrypted private folder on an already-configured VM

The repo contains a set of configurations (not applied by default) to set up an encrypted private folder using a user-supplied password. This private folder can be used to keep personal credentials private as described in the [OFO internal documentation](https://docs.openforestobservatory.org/internal-docs/jetstream).

This should only be applied to a VM that you will consider "yours" -- i.e., not to a VM that will serve as a template/image for others to create VMs from.

To apply it, run the following from an already-configured OFO dev VM:

```
 ansible-pull -U https://github.com/open-forest-observatory/ofo-ansible -i inventory -e RUN_MAIN=no -e RUN_PRIVATE=yes -e CREDS_PASSWORD=<password>
```
but replacing `<password>` with a password you will remember to decrypt your private folder. **Be sure to put a space before the entire command so that it is not stored in the instance's bash history.**
