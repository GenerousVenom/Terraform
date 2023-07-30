#!/usr/bin/env bash
if ! command -v multipass &> /dev/null
then
    echo "multipass could not be found"
    echo "Check <https://github.com/canonical/multipass> on how to install it"
    exit
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Default to 3 VMs
# NUMBER_OF_VMS=${1:-3}
NUMBER_OF_VMS=3

echo "Create cloud-init to import ssh key..."

# https://github.com/canonical/multipass/issues/965#issuecomment-591284180
cat <<EOF > "${DIR}"/cloud-init_SSHKey_U22.yml
---
users:
  - name: ansible
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /usr/bin/bash
    ssh_authorized_keys:
      - $( cat "$(ls -1 ~/.ssh/id_*.pub | head -1)" )
    package_update: true
    package_upgrade: true
runcmd:
  - echo Insert content successed >> /home/ansible/note.txt
  - systemctl disable ufw
  - systemctl stop ufw
write_files:
  - path: /etc/hostname
    content: |
      host-name-ansible
EOF
echo "Completing cloud-init"

for ((i = 1 ; i <= ${NUMBER_OF_VMS} ; i++)); do
  echo "[${i}/${NUMBER_OF_VMS}] Creating instance Ansible-${i} with multipass..."
  multipass launch \
  --name ansible-"${i}" \
  --cpus 1 \
  --mem 1024M \
  --disk 5G \
  --cloud-init "${DIR}"/cloud-init_SSHKey_U22.yml
done

multipass list 