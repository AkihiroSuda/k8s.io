/*
Copyright 2023 The Kubernetes Authors.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

###############################################
# VPC
###############################################

# VPC is IPv4/IPv6 Dual-Stack, but our cluster is IPv4 because EKS doesn't
# support dual-stack yet.

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = "${var.cluster_name}-vpc"
  cidr = var.vpc_cidr

  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 6, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 6, k + length(local.azs))]

  # intra_subnets are private subnets without the internet access 
  # (https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest#private-versus-intra-subnets)
  intra_subnets = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 6, k + (length(local.azs) * 2))]

  # Enable IPv6 for this subnet.
  enable_ipv6                     = true
  assign_ipv6_address_on_creation = true
  create_egress_only_igw          = true

  public_subnet_ipv6_prefixes  = [0, 4, 8]
  private_subnet_ipv6_prefixes = [12, 16, 20]
  intra_subnet_ipv6_prefixes   = [24, 28, 32]

  # NAT Gateway allows connection to external services (e.g. Internet).
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  # Tags to allow ELB (Elastic Load Balancing).
  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  tags = local.tags
}
