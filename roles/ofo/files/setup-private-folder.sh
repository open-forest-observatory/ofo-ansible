#! /bin/bash

sudo apt install ecryptfs-utils expect -y

echo "Enter an encryption password: "
read -s password

ecryptfs-setup-private -u exouser -l $password -m $password --force

echo "alias dec='ecryptfs-mount-private'" >> ~/.bashrc
echo "alias enc='ecryptfs-umount-private'" >> ~/.bashrc
source ~/.bashrc

expect -c "
  spawn ecryptfs-mount-private
  expect \"Enter your login passphrase:\"
  send \"$password\r\"
  interact
"
### Set up the git credentials file
# Original creds file and its destination in the secure folder
source_file="/home/exouser/.git-credentials"
destination_file="/home/exouser/Private/.git-credentials"

## Move the original creds file if it exists, otherwise create it
if [ -f $source_file ]; then
  mv $source_file $destination_file
else
  touch "${destination_file}"
fi

# Create the symlink in the expected location, pointing to the actual file
ln -s /home/exouser/Private/.git-credentials /home/exouser/.git-credentials
