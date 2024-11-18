# Installation and Setup of Pass and Git Credential Manager (GCM)

This guide outlines the installation and configuration process for the **pass** password manager and the **Git Credential Manager** (GCM) on Ubuntu or other Debian-based distributions. The goal is to integrate password management with GPG for **pass** and configure Git to use GCM for storing and managing credentials securely.

## Requirements

- Debian-based system (e.g., Ubuntu).
- Root access to install packages.
- GPG (GNU Privacy Guard) installed or the ability to install it.

## Steps

### 1. Install Pass

**Pass** is a simple password manager that uses GPG to encrypt and securely store passwords.

```bash
sudo apt install pass
```

### 2. Check if GPG is Installed

Make sure GPG is installed on your system. The script will automatically check if GPG is available, and if it's not installed, it will show an error message.

```bash
which gpg
```

This will show _/usr/bin/gpg_ or a similar binary path.

### 3. Generate a GPG Key

If GPG is not already set up on your system, you can generate a GPG key using the following command. GPG will be used to encrypt your passwords in **pass**.

```bash
gpg --gen-key
```

Follow the prompts to create a GPG key. Choose the key type and configure the key details (name, email, etc.).

### 4. Initialize Pass

After generating your GPG key, initialize **pass** with the generated key. Replace `<gpg-id>` with the ID of your GPG key, which you can find using the command `gpg --list-keys`.

```bash
pass init <gpg-id>
```

This will configure **pass** to use the GPG key for encrypting your passwords.

### 5. Configure Git to Use GPG for Credential Storage

Configure Git to use GPG for securely storing credentials.

```bash
git config --global credential.credentialStore gpg
```

This will set Git to store your credentials securely using GPG encryption.

### 6. Download and Install Git Credential Manager (GCM)

**Git Credential Manager (GCM)** is a tool that helps with authentication for Git repositories, such as GitHub, GitLab, etc. You can manually install GCM via the `.deb` package:

```bash
cd /tmp
curl --proto '=https' --tlsv1.2 -sSf -L -R -O https://github.com/git-ecosystem/git-credential-manager/releases/download/v2.6.0/gcm-linux_amd64.2.6.0.deb
```

Next, install the downloaded `.deb` package:

```bash
sudo dpkg -i gcm-linux_amd64.2.6.0.deb
```

After installation, GCM will be configured to securely manage your credentials.

## Conclusion

You have now successfully set up **pass** to manage your passwords using GPG and configured **Git Credential Manager** to use GPG encryption for Git credentials.

If you encounter any issues during the process, double-check that GPG is configured correctly and that Git is using GCM for credential management.

## Useful Links

- [Pass - Password Manager](https://www.passwordstore.org/)
- [Git Credential Manager](https://github.com/git-ecosystem/git-credential-manager)
