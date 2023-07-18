# Running init.yml
This playbook should only need to be run once and it will require the user's
login password, after this is run an ssh key will be installed on the remote
system and can be used for passwordless login.

## Generate the ssh key
```bash
ssh-keygen -t rsa -f "${HOME}/.ssh/fedora-remote" -N ''
```

## Run the playbook
```bash
ansible-playbook -i inventory.yml --ask-pass --ask-become-pass init.yml
```

# Running provision.yml
This playbook will install all needed utilities in the remote system. In case
a new utility is needed, it should be added to the playbook and re-run.

## Run the playbook
```bash
ansible-playbook -i inventory.yml --ask-become-pass provision.yml
```
