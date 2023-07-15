awk '{$1=""}1' # Eliminates 1st row in output.
ldd $(which sshd) | awk '{$4=""}1' | grep -E '^libp[a-m]+'