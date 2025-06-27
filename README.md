# Basic VPS Setup

Because you need the basics...

### How to run the setup script from your local machine

1. **Upload script to your new VPS** (replace `root` and `your.vps.ip` accordingly):

```bash
scp first-setup.sh root@your.vps.ip:~
```

2. **SSH into your VPS as root** (assuming root access is initially enabled):

```bash
ssh root@your.vps.ip
```

3. **Run the script on the VPS:**

```bash
chmod +x first-setup.sh
./first-setup.sh
```

4. **Follow prompts** (create new user, paste SSH key, allow app port, etc.)

5. **After this, you’ll connect going forward as the new user you created, with SSH key auth and firewall rules in place.**
