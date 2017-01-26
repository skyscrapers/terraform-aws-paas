# terraform-aws-paas
Repository containing TF modules aimed at interacting with AWS Beanstalk &amp; Opsworks

## AWS Beanstalk
Creates an AWS Beanstalk application and environment.

### Available variables:
 * [`vpc_id`]: String(required): the VPC in which the Beanstalk app needs to be created
 * [`app_name`]: String(required): the Beanstalk application name
 * [`environment`]: String(required): Custom environment name
 * [`project`]: String(required): Custom project name
 * [`instance_type`]: String(required): EC2 instance type to use for running the Beanstalk application.
 * [`instance_subnet_ids`]: List(required):  The subnets to be used to deploy the Beanstalk EC2 instances in.
 * [`sg_app_id`]: String(required): The security group to attach to the Beanstalk application instances.
 * [`elb_subnet_ids`]: List(required):  The subnets to be used for the ELB
 * [`sg_elb_id`]: String(required): The security group to attach to the load balancer fronting the Beanstalk application
 * [`max_size`]: Integer(required): The maximum number of instances backing the Beanstalk application
 * [`min_size`]: Integer(required): The minimum number of instances backing the Beanstalk application
 * [`ssh_key`]: String(required): The SSH key to deploy on the backing instances.
 * [`healthcheck`]: String(optional): The protocol and port to use for health checking the backing Beanstalk instances.
 * [`service_role`]: Service role
 * [`monitoring_type`]: Monitoring type.

 ### Output
 * [`ids`]: List: The ids of the nat gateways created.

### Example
  ```
  module "beanstalk_app" {
    source = "github.com/skyscrapers/terraform-aws-paas//beanstalk?ref=<hash_or_tag>"
    vpc_id="${module.vpc.vpc_id}"
    public_subnets="${module.vpc.public_subnets}"
  }
  ```
