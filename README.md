# ??? Enterprise Azure Terraform Modules Framework

[![Terraform](https://img.shields.io/badge/Terraform-1.7%2B-8A2BE2?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Azure Provider](https://img.shields.io/badge/azurerm-3.100%2B-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white)](https://registry.terraform.io/providers/hashicorp/azurerm/latest)
[![DevSecOps](https://img.shields.io/badge/Security-tfsec_%7C_Checkov-00A2FF?style=for-the-badge)](https://github.com/gunjankumargaurav7350)
[![Author](https://img.shields.io/badge/Architect-Gunjan_Kumar_Gaurav-0A0E27?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/gunjan-gaurav)

Production-grade, modular Infrastructure-as-Code (IaC) framework engineered for multi-subscription **Microsoft Azure Landing Zones** following the **Cloud Adoption Framework (CAF)** and Zero-Trust architecture.

---

## ? Key Architectural Capabilities

- **`for_each` & Map Objects Pattern:** Every module accepts structured maps of objects with strongly-typed schemas, enabling entire multi-tiered topologies (subnets, NSGs, VMs, and disks) to be provisioned through single declarative data structures without code duplication.
- **`dynamic` Blocks Mastery:** Full implementation of `dynamic` configuration blocks:
  - `azurerm_network_security_group` -> `dynamic "security_rule"`
  - `azurerm_application_gateway` -> `dynamic "frontend_port"`, `backend_address_pool"`, `http_listener"`, `request_routing_rule"`, `probe"`
  - `azurerm_virtual_network` -> `dynamic "delegation"` for AKS and App Service
  - `azurerm_key_vault` -> `dynamic "network_acls"` & `dynamic "access_policy"`
  - `azurerm_kubernetes_cluster` -> `dynamic "ingress_application_gateway"`, `key_vault_secrets_provider"`, `oms_agent"`
- **Strict Semantic Versioning & State Governance:** Remote backend with blob lease locking, Customer-Managed Keys (CMK), and automated drift detection pipelines.

---

## ?? Repository Topology

```
+-- modules/
¦   +-- network-security-group/     # Dynamic rule matrix over maps
¦   +-- virtual-network/            # for_each subnets with dynamic delegations
¦   +-- application-gateway/        # Dynamic WAF listeners, pools & probes
¦   +-- key-vault/                  # Dynamic network ACLs & access policies
¦   +-- virtual-machine/            # for_each NICs & dynamic data disks
¦   +-- aks-cluster/                # Dynamic AGIC ingress & secrets provider
+-- environments/
¦   +-- production/                 # Production root deployment orchestrator
¦       +-- main.tf                 # Multi-module orchestration
¦       +-- variables.tf            # Typed variable schemas
¦       +-- terraform.tfvars        # Real enterprise production configuration
¦       +-- provider.tf             # Azure remote backend locking
+-- README.md
```

---

## ?? Usage & Deployment

```bash
cd environments/production

# 1. Format & Validate
terraform fmt -check
terraform validate

# 2. Plan with Speculative Drift Detection
terraform plan -out=tfplan.binary

# 3. Apply changes
terraform apply tfplan.binary
```

---

## ?? Author & Architecture Inquiries

**Gunjan Kumar Gaurav**  
*Senior Cloud & DevSecOps Consultant | Azure Solutions Architect Expert (AZ-305)*  
LinkedIn: [linkedin.com/in/gunjan-gaurav](https://www.linkedin.com/in/gunjan-gaurav) | Email: `gunjankumargaurav7@gmail.com`
