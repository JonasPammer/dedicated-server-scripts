# HOWTO
First Checkout:
```bash
# Make sure sudo is installed (or at least running as root):
user@host $ apt install sudo git -y
# Make & Go into the directory in which the downloaded repo to live in:
user@host $ sudo mkdir -p /var/pixeltutorials-root_server-scripts/ && cd /var/pixeltutorials-root_server-scripts/

# Initialize:
user@host /var/pixeltutorials-root_server-scripts $ git init .
user@host /var/pixeltutorials-root_server-scripts $ git remote add origin https://PixelTutorials@github.com/PixelTutorials/dedicated-server-scripts.git
```

Update:
```bash
# Always get newest and overwrite any local changes
user@host /var/pixeltutorials-root_server-scripts $ git fetch --all
user@host /var/pixeltutorials-root_server-scripts $ git reset --hard
# Pull
user@host /var/pixeltutorials-root_server-scripts $ git pull origin master
# Enter Personal Access Token (when using 2FA) or password...
```

Usage:
```bash
user@host /var/pixeltutorials-root_server-scripts $ chmod +x start
user@host /var/pixeltutorials-root_server-scripts $ sudo ./start
```