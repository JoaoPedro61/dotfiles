# Step by step to configure GCM

## Make sure that you have a git installed
```bash
sudo apt-get install git-all
```

## Make sure that you have installed the package "pass"
```bash
sudo apt install pass
```

## Make sure that you have installed the package "pass"
```bash
sudo apt install pass
```

## Set the credential manager on git config
```bash
git config --global credential.credentialStore gpg
```

## Generate a new GPG Key
```bash
gpg --gen-key
```
Don't forget the secret phrase, because you will need it as a password, you need inform it on git commands like:
* git pull
* git push
* etc

## Generage a new "pass" password manager
```bash
pass init <gpg-id>
```
The _<gpg-id>_ can be found in the last executed command. Otherwise you can list ids of gpg using the command:
```bash
gpg --list-key
```

## Finally install de CGM

### Install using DPKG

Download the _.deb_ package:
```bash
wget https://github.com/git-ecosystem/git-credential-manager/releases/download/v2.4.1/gcm-linux_amd64.2.4.1.deb
```
Install the _.deb_ package:
```bash
sudo dpkg -i ./gcm-linux_amd64.2.4.1.deb
```
Run configuration script:
´´´bash
git-credential-manager configure
´´´

### Install using Tarball

Download the _.tar.gz_ package:
```bash
wget https://github.com/git-ecosystem/git-credential-manager/releases/download/v2.4.1/gcm-linux_amd64.2.4.1.tar.gz
```
Install the _.tar.gz_ package:
```bash
sudo tar -xvf gcm-linux_amd64.2.4.1.tar.gz -C /usr/local/bin
```
Run configuration script:
´´´bash
git-credential-manager configure
´´´
