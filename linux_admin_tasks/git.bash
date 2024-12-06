# Generate a key pair.
ssh-keygen -t rsa -N "" -b 4096 -C "centos"

# Paste the public key on github.com

# Clone the repository locally.
git clone git@github.com:pranshu-paul/Unix.git /root/repo/git

# To set the global email and user name.
git config --global user.email "paulpranshu@gmail.com"
git config --global user.name "Pranshu Paul"

# Commit the changes with a message.
git commit -a -m commit

# Push the changes.
git push

# Update the repo if the changes are made to another server.
git pull

# To check the current branch.
git branch

# Create & switch to a new branch.
git switch -c dev

# Switch back to prod.
git switch prod

# Switch to the dev branch.
git switch dev

# stage the files on the dev branch.
git add <file1> <file2>

# Commit the changes in the dev branch
git commit -m "Changed the task one"

# If the changes are successful. We have to push the changes in the prod branch.
git switch prod

# Megre the brances.
git merge dev

# If want to discard the changes from the branch merging.
git reset --hard HEAD~1

# To check the git log
git log
