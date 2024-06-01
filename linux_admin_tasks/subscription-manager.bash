# To install subscription-manager.
yum -y install subscription-manager

subscription-manager

# To attach a new subscription if there is no attached.
subscription-manager register --auto-attach
subscription-manager register --username <user_name> --password <password> --auto-attach

# To just register the system to tget access to the RedHat CDN (repository)
subscription-manager register --username <user_name>

# To attach subscription if it's already attached.
subscription-manager register --auto-attach --force

# To check subscription id.
subscription-manager identity