steps:
1. copy ~/.config/kopia, ~/.config/nix, ~/.config/age, and ~/.ssh onto an external drive
2. disable secure boot and put the TPM in setup mode.
3. boot into the live installer
4. mount the external drive with the config files in it
5. run disks.sh, install.sh, and copy.sh
6. reboot the system, and wait for it to generate and enroll the secure boot keys.
7. after it has rebooted and been setup, run tpm-fde.sh and restore.sh
8. after restore.sh has finished run `first_boot.sh`
