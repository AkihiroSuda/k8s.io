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

# playground account to experiment e2e tests on AWS
module "aws-playground-01" {
  source = "../modules/org-account"

  account_name = "k8s-infra-e2e-aws-playground-01"
  email        = "k8s-infra-aws-admins+aws-playground-01@kubernetes.io"
  parent_id    = aws_organizations_organizational_unit.non_production.id
  tags = {
    "production" = "false",
    "owners"     = "upodroid"
  }
}