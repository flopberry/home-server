**Create proxmox user:**

Run this command in proxmox cli
```
pveum user add terraform@pve  # Create terraform user
pveum role add Terraformer -privs "Datastore.AllocateSpace Datastore.AllocateTemplate Datastore.Audit Pool.Allocate Sys.Audit Sys.Console Sys.Modify VM.Allocate VM.Audit VM.Clone VM.Config.CDROM VM.Config.Cloudinit VM.Config.CPU VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Migrate VM.Monitor VM.PowerMgmt SDN.Use"  # Create Terraformer role
pveum aclmod / -user terraform@pve -role Terraformer  # Set Terraformer role to terraform user
pveum user token add terraform@pve terraform --privsep=0  # Create auth token. You need to copy it from output
```
Then copy token to your vers file


**Configure vars file:**

```
cp vars.yaml.example vars.yaml
vim vars.yaml
```
And edit your variable to finish setup


**Start deploying:**

```
terraform init  # initialize terraform and install plugins
terraform plan  # to see what changes will be
terraform apply  # to deploy VMs. Then type yes to confirm
ansible-playbook playbook.yaml  # To configure VMs
```
