### Configure Azure VPC

Below steps will provision Azure VPC required for IBM Spectrum Scale cloud solution.

1. Change working directory to `azure_scale_templates/sub_modules/vpc_template`.

    ```cli
    cd ibm-spectrum-scale-cloud-install/azure_scale_templates/sub_modules/vpc_template/
    ```

2. Create terraform variable definitions file (`terraform.tfvars.json`) and provide infrastructure inputs.

    Minimal Example:

    ```json
    {
        "client_id": "f5b6a5cf-fbdf-4a9f-b3b8-3c2cd00225a4",
        "client_secret": "0e760437-bf34-4aad-9f8d-870be799c55d",
        "tenant_id": "72f988bf-86f1-41af-91ab-2d7cd011db47",
        "subscription_id": "e652d8de-aea2-4177-a0f1-7117adc604ee",
        "vpc_location": "eastus",
        "resource_group_name": "spectrum-scale",
        "resource_prefix": "spectrum-scale",
        "vpc_address_space": ["10.0.0.0/16"],
        "vpc_public_subnet_address_spaces": ["10.0.1.0/24"],
        "vpc_strg_priv_subnet_address_spaces": ["10.0.2.0/24"],
        "vpc_comp_priv_subnet_address_spaces": ["10.0.3.0/24"],
        "comp_dns_domain": "strgscale.com",
        "strg_dns_domain": "compscale.com",
        "storage_account_name": "spectrumscalestorageaccnt",
        "vpc_tags": {
            "Region": "eastus",
            "Evnironment": "Staging"
        }
    }
    ```

3. Run `terraform init` and `terraform apply -auto-approve` to provision resources.

<!-- BEGIN_TF_DOCS -->
#### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | ~> 1.3 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement_azurerm) | ~> 3.37 |

#### Inputs

| Name | Description | Type |
|------|-------------|------|
| <a name="input_client_id"></a> [client_id](#input_client_id) | The Active Directory service principal associated with your account. | `string` |
| <a name="input_client_secret"></a> [client_secret](#input_client_secret) | The password or secret for your service principal. | `string` |
| <a name="input_subscription_id"></a> [subscription_id](#input_subscription_id) | The subscription ID to use. | `string` |
| <a name="input_tenant_id"></a> [tenant_id](#input_tenant_id) | The Active Directory tenant identifier, must provide when using service principals. | `string` |
| <a name="input_vnet_location"></a> [vnet_location](#input_vnet_location) | The location/region of the vnet to create. Examples are East US, West US, etc. | `string` |
| <a name="input_comp_dns_domain"></a> [comp_dns_domain](#input_comp_dns_domain) | Azure DNS domain name to be used for compute cluster. | `string` |
| <a name="input_resource_prefix"></a> [resource_prefix](#input_resource_prefix) | Prefix is added to all resources that are created. | `string` |
| <a name="input_strg_dns_domain"></a> [strg_dns_domain](#input_strg_dns_domain) | Azure DNS domain name to be used for storage cluster. | `string` |
| <a name="input_vnet_address_space"></a> [vnet_address_space](#input_vnet_address_space) | The CIDR block for the vnet. | `list(string)` |
| <a name="input_vnet_comp_priv_subnet_address_spaces"></a> [vnet_comp_priv_subnet_address_spaces](#input_vnet_comp_priv_subnet_address_spaces) | List of cidr_blocks for compute cluster private subnets. | `list(string)` |
| <a name="input_vnet_public_subnet_address_spaces"></a> [vnet_public_subnet_address_spaces](#input_vnet_public_subnet_address_spaces) | List of cidr_blocks of public subnets. | `list(string)` |
| <a name="input_vnet_strg_priv_subnet_address_spaces"></a> [vnet_strg_priv_subnet_address_spaces](#input_vnet_strg_priv_subnet_address_spaces) | List of cidr_blocks for storage cluster private subnets. | `list(string)` |
| <a name="input_vnet_tags"></a> [vnet_tags](#input_vnet_tags) | The tags to associate with your network and subnets. | `map(string)` |

#### Outputs

| Name | Description |
|------|-------------|
| <a name="output_compute_priv_dns_zone_name"></a> [compute_priv_dns_zone_name](#output_compute_priv_dns_zone_name) | The dns zone for compute private zone. |
| <a name="output_resource_group_name"></a> [resource_group_name](#output_resource_group_name) | New resource group name |
| <a name="output_storage_priv_dns_zone_name"></a> [storage_priv_dns_zone_name](#output_storage_priv_dns_zone_name) | The dns zone for storage private zone. |
| <a name="output_vnet_compute_cluster_private_subnets"></a> [vnet_compute_cluster_private_subnets](#output_vnet_compute_cluster_private_subnets) | List of IDs of compute cluster private subnets. |
| <a name="output_vnet_id"></a> [vnet_id](#output_vnet_id) | The ID of the vnet. |
| <a name="output_vnet_public_subnets"></a> [vnet_public_subnets](#output_vnet_public_subnets) | List of IDs of public subnets. |
| <a name="output_vnet_storage_cluster_private_subnets"></a> [vnet_storage_cluster_private_subnets](#output_vnet_storage_cluster_private_subnets) | List of IDs of storage cluster private subnets. |
<!-- END_TF_DOCS -->
