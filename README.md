<style>
blue1 {
  color: #051AE1
}
</style>

<style>
blue2 {
  color: #6699FF
}
</style>

# Some useful Azure CLI for Terraform
## Abbreviation
- -l: Location
- -p: Publisher
- -f: Offer
- -o: Output

## How to find *source_image_reference* in Azure
You can click [here](https://learn.microsoft.com/en-us/azure/virtual-machines/windows/cli-ps-findimage) for more information
<p align="center">
  <img src="Azure Image Flow.png" alt="Image Description">
</p>

In order to file *source_image_reference* in Azure to create Terraform file, you have to follow the above steps
- Find Publisher following [this command](https://learn.microsoft.com/en-us/cli/azure/vm/image?view=azure-cli-latest#az-vm-image-list-publishers)
  > <blue1>az vm image list-publishers </blue1> <blue2>-l</blue2> eastasia <blue2>--query</blue2> "[?starts_with(name, 'Open')]" <blue2>-o</blue2> table
  
  Some common Publishers:
  - MicrosoftWindows
  - OpenLogic (CentOS)
  - RedHat (RHEL)
  - Canonical (Ubuntu)

- Find Image Offer following [this command](https://learn.microsoft.com/en-us/cli/azure/vm/image?view=azure-cli-latest#az-vm-image-list-offers)
  > <blue1>az vm image list-offers</blue1> <blue2>-l</blue2> eastasia <blue2>-p</blue2> OpenLogic <blue2>-o</blue2> table

- Find SKU following [this command](https://learn.microsoft.com/en-us/cli/azure/vm/image?view=azure-cli-latest#az-vm-image-list-skus)
  > <blue1>az vm image list-skus</blue1> <blue2>-l</blue2> eastasia <blue2>-p</blue2> OpenLogic <blue2>-f </blue2>CentOS -o table

- Find full image following [this command](https://learn.microsoft.com/en-us/cli/azure/vm/image?view=azure-cli-latest#az-vm-image-show)
  > <blue1>az vm image show</blue1> <blue2>-l</blue2> eastasia <blue2>--urn</blue2> OpenLogic:CentOS:7.3:latest -o table