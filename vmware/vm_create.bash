#!/bin/sh

# Log in to ESXi Shell

datastore=/vmfs/volumes/datastore1
vm_name=srv05
vm_path="${datastore}/${vm_name}"
iso=rhel-9.3-x86_64-boot.iso
storage_size=10
storage_type=thin

create_vm() {
# Create a directory to store the VM files.
mkdir -p "$vm_path"

# Create the vm.vmx file

cat > "${vm_path}/${vm_name}.vmx" <<EOF
.encoding = "UTF-8"
config.version = "8"
virtualHW.version = "21"
memSize = "4096"
numvcpus = "6"
cpuid.coresPerSocket = "1"
floppy0.present = "FALSE"
displayName = "$vm_name"
guestOS = "rhel8-64"
firmware = "efi"
sata0.present = "TRUE"
sata0:0.present = "TRUE"
sata0:0.deviceType = "cdrom-image"
sata0:0.fileName = "$datastore/$iso"
sata0:1.present = "TRUE"
sata0:1.fileName = "${vm_name}.vmdk"
sata0:1.deviceType = "disk"
ethernet0.present = "TRUE"
ethernet0.networkName = "VM Network"
ethernet0.addressType = "generated"
EOF

# Create a 4 gb with a virtual Paravirtual SCSI interface
vmkfstools --createvirtualdisk "$storage_size"G --diskformat "$storage_type" "${vm_path}/${vm_name}.vmdk"

# Register the VM
vm_id=$(vim-cmd solo/register "${vm_path}/${vm_name}.vmx")

# Power on the VM id
vim-cmd vmsvc/power.on "$vm_id"
}

other() {
# Lis the VMs
vim-cmd vmsvc/getallvms

# Reload the settings. This can be useful when we make changes in the ".vmx" files
vim-cmd vmsvc/reload 6
}

remove_vm() {
        vm_id=$(vim-cmd vmsvc/getallvms | grep -w $vm_name | awk '{print $1}')

        if [ -z "$vm_id" ]; then
        echo "VM '$vm_name' not found."
        exit 1
    fi

        vim-cmd vmsvc/power.off "$vm_id"
        vim-cmd vmsvc/unregister "$vm_id"
        rm -rfv "$vm_path"
}

main() {
while getopts ":cr" opt; do
  case "$opt" in
    c)
      create_vm
      ;;
    r)
      remove_vm
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done
}

main "$1"