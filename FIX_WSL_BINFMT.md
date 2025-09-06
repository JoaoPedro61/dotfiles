# Windows Sub-System for Linux

Follow this step to fix the binfmt error!

### In WSL

1. Update headers
   ```bash
   sudo apt update
   ```
   ```bash
   sudo apt upgrade
   ```
   ```bash
   sudo apt autoremove
   ```

2. Create Intrerop.conf file:
   ```bash
   sudo vi /usr/lib/binfmt.d/WSLInterop.conf
   ```

3. Put this content in the Interop.conf file:
   ```text
   :WSLInterop:M::MZ::/init:PF
   ```

4. Restart related binfmt services:
   ```bash
   sudo systemctl restart systemd-binfmt
   ```

5. If at restarting you get some error, install the support to binfmt, and restart service again:
   ```bash
   sudo apt install binfmt-support
   sudo systemctl restart binfmt-support
   ```
