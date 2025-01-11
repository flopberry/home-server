**Create proxmox user:**

Run this command in proxmox cli
```
pveum user add ansible@pve  # Create ansible user
pveum role add Ansibler -privs "Datastore.AllocateSpace Datastore.AllocateTemplate Datastore.Audit Pool.Allocate Sys.Audit Sys.Console Sys.Modify VM.Allocate VM.Audit VM.Clone VM.Config.CDROM VM.Config.Cloudinit VM.Config.CPU VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Migrate VM.Monitor VM.PowerMgmt SDN.Use"  # Create Ansibler role
pveum aclmod / -user ansible@pve -role Ansibler  # Set Ansibler role to terraform user
pveum user token add ansible@pve ansible --privsep=0  # Create auth token. You need to copy it from output
```
Then copy token to your vers file


**Configure vars file:**

```
cp vars.yaml.example vars.yaml
vim vars.yaml
cp proxmox.yaml.example proxmox.yaml
vim proxmox.yaml
```
And edit your variable to finish setup


**Start deploying:**

```
ansible-playbook playbook.yaml  # To configure proxmox 
```
