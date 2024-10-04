# Bootstrap

- [Bootstrap](#bootstrap)
  - [Deployment Role](#deployment-role)
  - [Terraform State](#terraform-state)
    - [Input Parameters](#input-parameters)
    - [Deploy](#deploy)

This project includes infrastructure resources that must be deployed separately
and prior to any FilmDrop resources.

## Deployment Role

The deployment Role is an IAM Role that is assumed when deploying all FilmDrop infrastructure.

The deployment Role should be created once per AWS Account.

You can deploy this role through CloudFormation
with the following command:

```shell
aws cloudformation deploy \
  --stack-name "appFilmDropGooseDeployRoleBootstrap" \
  --template-file bootstrap/deploy_role_cfn.yml \
  --capabilities=CAPABILITY_NAMED_IAM
```

## Terraform State

FilmDrop resources are deployed as [Terraform](https://www.terraform.io/) modules
which require a managed state file as part of the deployment. This project
bootstraps the resources necessary to support the Terraform state file and
backend configuration.

The Terraform state S3 Bucket and DynamoDB Table should be created once per AWS
Account + Region.

### Input Parameters

Input parameters for the Terraform state file resources are found in
[terraform_state_params.json](./terraform_state_params.json) and should be
modified for your project.

The Terraform state S3 Bucket name must be globally unique - it's recommended to
use a combination or your AWS account alias, deploy region, and a random suffix
in order to ensure uniqueness. For example:

```text
filmdrop-myProjectAccount-us-west-2-terraform-state-96842
```

The DynamoDB locks table name must be a unique name per AWS account and region.
The table name defaults to `filmdrop-terraform-state-locks`, but can be overridden.

### Deploy

You can deploy these resources through CloudFormation with the following command,
substituting the value of `TerraformStateBucketName`.

```shell
aws cloudformation deploy \
  --stack-name "appFilmDropGooseTerraformStateBootstrap" \
  --template-file bootstrap/terraform_state_cfn.yml \
  --parameter-overrides \
    TerraformStateBucketName=REPLACEME
```

Once deployed you'll need the S3 Bucket name and DynamoDB table name to configure
the Terraform backend. You'll add those values to the FilmDrop infrastructure
project later.
