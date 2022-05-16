# Compute Engine


Terraform Init
```t
terraform -chdir=terraform/ init  -backend-config="bucket=ct-sandbox-tf-state" -backend-config="prefix=prod/create_compute_engine/" -reconfigure
```

Terraform Plan
```t
terraform -chdir="terraform/" plan -out out.terraform_create_compute_engine
```

Terraform Apply
```t
terraform -chdir="terraform/" apply out.terraform_create_compute_engine
```