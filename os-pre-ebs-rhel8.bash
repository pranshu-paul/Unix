#!/bin/bash
# This script is EXCLUSIVE for RHEL 8.

# Declare variables and arrays.
domain_name="rhel.com"
host_name="srv_el8"
fqdn="${host_name}.${domain_name}"
time_zone="Asia/Kolkata"

oracle_user=oracle
oracle_uid=54321
primary_group=oinstall
primary_gid=54321
secondary_group=dba
secondary_gid=54322

delcare -a packages

packages=(
"bc.$(uname -m)"
"binutils.$(uname -m)"
"elfutils-libelf.$(uname -m)"
"elfutils-libelf-devel.$(uname -m)"
"fontconfig-devel.$(uname -m)"
"glibc.$(uname -m)"
"glibc-devel.$(uname -m)"
"ksh.$(uname -m)"
"libaio.$(uname -m)"
"libaio-devel.$(uname -m)"
"libXrender.$(uname -m)"
"libX11.$(uname -m)"
"libXau.$(uname -m)"
"libXi.$(uname -m)"
"libXtst.$(uname -m)"
"libgcc.$(uname -m)"
"libnsl.$(uname -m)"
"librdmacm.$(uname -m)"
"libstdc++.$(uname -m)"
"libstdc++-devel.$(uname -m)"
"libxcb.$(uname -m)"
"libibverbs.$(uname -m)"
"make.$(uname -m)"
"policycoreutils.$(uname -m)"
"policycoreutils-python-utils.$(uname -m)"
"smartmontools.$(uname -m)"
"sysstat.$(uname -m)"
)

PKGS=($(rpm -q "${packages[@]}" | awk '{print $2}' | sort | sed '/^$/d'))

system_limits=(
"* soft nofile 1024"
"* hard nofile 65536"
"* soft nproc 16384"
"* hard nproc 16384"
"* soft stack 10240"
"* hard stack 32768"
)

kernel_parameters=(
"net.ipv4.ip_forward=0"
"net.ipv4.conf.default.rp_filter=1"
"net.ipv4.conf.default.accept_source_route=0"
"kernel.sysrq=0"
"kernel.core_uses_pid=1"
"net.ipv4.tcp_syncookies=1"
"kernel.msgmnb=65536"
"kernel.msgmax=65536"
"kernel.shmall=4294967296"
"fs.file-max=6815744"
"kernel.sem=256 32000 100 142"
"kernel.shmmni=4096"
"kernel.shmmax=4398046511104"
"kernel.msgmni=2878"
"net.core.rmem_default=262144"
"net.core.rmem_max=4194304"
"net.core.wmem_default=262144"
"net.core.wmem_max=1048576"
"fs.aio-max-nr=1048576"
"net.ipv4.ip_local_port_range=9000 65500"
)

if [[ $UID != 0 ]]; then
    echo "Please run this script either with root user or sudo permission."
    exit 1
fi

set_timezone () {
if [[ $(timedatectl | grep -o "${time_zone}") != "${time_zone}" ]]; then
	timedatectl set-timezone "${time_zone}"
	echo Timezone is "$(timedatectl | grep -o "${time_zone}")."
else
	echo -e "\nTimezone is already set.\n$(timedatectl | grep -o ${time_zone})"
fi
}

set_sysname () {
local ip=$(hostname -I | awk '{print $1}')
local hosts_entry="${ip} ${fqdn} ${sysName}"

	if ! grep -oq "${hosts_entry}" /etc/hosts || \
		[[ "$(hostname)" != "${sysName}" || "$(hostname -f)" != "${fqdn}" ]]; then
		echo -e "\nChanging hostname to ${sysName} and FQDN to ${fqdn}."
		echo "${hosts_entry}" >> /etc/hosts
		hostnamectl set-hostname "${sysName}"
		echo "Hostname and FQDN changed to ${sysName} and ${fqdn} respectively."
	else
		echo "FQDN is already set to $(hostname -f)."
	fi
}

install_packages () {
if [[ -n "${PKGS[@]}" ]]; then
	echo -e "\nInstalling package[s]: ${PKGS[@]}"
	dnf -y install "${PKGS[@]}" || { echo "Something went wrong while installing packages."; return 1; }
	printf "%s\n" 'Package[s] installed' "${PKGS[@]}"
else
	printf "%s\n" 'Package[s] already installed' "${PACKAGES[@]}"
fi
}

set_seperm () {
local permissive=$(grep -E '^SELINUX=permissive' /etc/selinux/config && echo 1)
	if [[ -z $permissive ]]; then
		sed -i 's/SELINUX=.*/SELINUX=permissive/' /etc/selinux/config
		setenforce 0
		echo -e "\nSELinux changed to permissive mode."
	else
		echo -e "\nSELinux is already in permissive mode."
	fi
}

pgroup () {
  if grep -q "${primaryGroup}\|${primaryGid}" /etc/group; then
    printf "\nGroup %s already exists.\n" "$primaryGroup"
    echo "$primaryGroup"
  else
    groupadd -g "$primaryGid" "$primaryGroup" && \
    printf "Primary group %s added with GID %s.\n" "$primaryGroup" "$primaryGid"
    echo "$primaryGroup"
  fi
}

sgroup () {
  if grep -q "${secondaryGroup}\|${secondaryGid}" /etc/group; then
    printf "\nGroup %s already exists.\n" "$secondaryGroup"
    echo "$secondaryGroup"
  else
    groupadd -g "$secondaryGid" "$secondaryGroup" &&\
    printf "Secondary group %s added with GID %s.\n" "$secondaryGroup" "$secondaryGid"
    echo "$secondaryGroup"
  fi
}

orauser () {
  if grep -q "${oraUser}\|${oraUid}" /etc/passwd; then
    printf "\nUser %s already exists.\n" "$oraUser"
  else
    useradd -u "$oraUid" -g "$(pgroup)" -G "$(sgroup)" "$oraUser" &&\
    printf "User %s added with UID %s, Primary group %s and Secondary group %s.\n" "$oraUser" "$oraUid" "$(pgroup)" "$(sgroup)"
  fi
}

# Verifying swap size.
echo -e "\nAvailable swap size: $(free -h | grep Swap | awk '{print $2}')"

# Minimum space in /usr/tmp must be 1G.
df -h /usr/tmp

# Function to add kernel parameters to /etc/sysctl.d/10-sysctl.conf
add_kernel_parameters () {
local file_path="/etc/sysctl.d/10-sysctl.conf"

	# Check if the file exists and has the expected contents
	if [[ -f "$file_path" && $(cat "$file_path") == "$(printf '%s\n' "${kernel_params[@]}")" ]]; then
		echo "Kernel parameters file already exists with the expected contents."
		return
	fi

	# Write the kernel parameters to the file
	printf '%s\n' "${kernel_params[@]}" | sudo tee "$file_path" > /dev/null
	echo "Kernel parameters added to $file_path"
}

add_limits_conf() {
local limits_file="/etc/security/limits.d/001_limits.conf"
	if [ -f "$limits_file" ] && grep -qF "${system_limits[*]}" "$limits_file"; then
		echo "Limits configuration already present in $limits_file"
	else
		echo "Adding limits configuration to $limits_file"
		printf '%s\n' "${system_limits[@]}" | sudo tee -a "$limits_file" > /dev/null
	fi
}