# Azure Core Infrastructure with Terraform

This project uses Terraform to deploy a foundational set of resources in Microsoft Azure. It's designed as a hands-on lab to demonstrate core Infrastructure as Code (IaC) principles.

The script will build a complete, working environment containing a resource group, a virtual network, a network security group (firewall), and a ready-to-use Linux virtual machine accessible via SSH.

## Prerequisites

Before you begin, ensure you have the following tools installed and configured:

1.  **Terraform**: [Download and install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli).
2.  **Azure CLI**: [Download and install the Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli).
3.  **An Azure Account**: You'll need an active Azure subscription. A [Free Account](https://azure.microsoft.com/en-us/free/) is sufficient.
4.  **SSH Key**: You must have an SSH key pair generated on your local machine. If you don't have one, you can create it with `ssh-keygen`.

## How to Use

1.  **Clone the Repository**
    ```bash
    git clone <your-repository-url>
    cd <your-repository-name>
    ```

2.  **Configure Authentication**
    Log in to your Azure account using the Azure CLI:
    ```bash
    az login
    ```

3.  **Update the VM with Your Public Key**
    Open the `main.tf` file and locate the `azurerm_linux_virtual_machine` resource. Replace the placeholder text in the `public_key` attribute with your own SSH public key.

4.  **Initialize Terraform**
    This command downloads the necessary Azure provider plugin.
    ```bash
    terraform init
    ```

5.  **Plan the Deployment**
    Run a dry-run to see what resources will be created.
    ```bash
    terraform plan
    ```

6.  **Apply the Configuration**
    This command will build the resources in Azure. You will be prompted to confirm the action.
    ```bash
    terraform apply
    ```
    After the apply is complete, Terraform will output the public IP address of the virtual machine.

## Resources Created

This project will create the following resources in Azure:

* **Resource Group**: A logical container for all project resources.
* **Virtual Network (VNet)**: An isolated network space for your resources.
* **Subnet**: A sub-division within the VNet.
* **Public IP Address**: A static public IP to access the VM.
* **Network Security Group (NSG)**: A firewall configured to allow inbound SSH traffic on port 22.
* **Network Interface (NIC)**: A virtual network card for the VM.
* **Linux Virtual Machine**: An Ubuntu Server LTS virtual machine.

## Connecting to the Virtual Machine

You can connect to the newly created VM using SSH. Use the public IP address provided in the `terraform apply` output.

```bash
ssh <admin_username>@<public_ip_address_from_output>

# Example:
# ssh labadmin@20.10.50.100

Cleaning Up
When you are finished, you can destroy all the resources created by this project to avoid incurring costs.

This action is irreversible.

terraform destroy

