resource "aws_elastic_beanstalk_application" "bstk_app" {
  name = "${var.app_name}"
}
resource "aws_iam_instance_profile" "BeanstalkEnhancedHealth" {
    name = "BeanstalkEnhancedHealth_${var.project}_${var.environment}_${var.app_name}"
    roles = ["${aws_iam_role.BeanstalkEnhancedHealth.name}"]
}

resource "aws_iam_role" "BeanstalkEnhancedHealth" {
   	name = "BeanstalkEnhancedHealth_${var.project}_${var.environment}_${var.app_name}"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "BeanstalkEnhancedHealth" {
    name = "BeanstalkEnhancedHealth_${var.project}_${var.environment}_${var.app_name}"
    role = "${aws_iam_role.BeanstalkEnhancedHealth.id}"
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "elasticloadbalancing:DescribeInstanceHealth",
        "elasticloadbalancing:DescribeLoadBalancers",
        "elasticloadbalancing:DescribeTargetHealth",
        "ec2:DescribeInstances",
        "ec2:DescribeInstanceStatus",
        "ec2:GetConsoleOutput",
        "ec2:AssociateAddress",
        "ec2:DescribeAddresses",
        "ec2:DescribeSecurityGroups",
        "sqs:GetQueueAttributes",
        "sqs:GetQueueUrl",
        "autoscaling:DescribeAutoScalingGroups",
        "autoscaling:DescribeAutoScalingInstances",
        "autoscaling:DescribeScalingActivities",
        "autoscaling:DescribeNotificationConfigurations"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

resource "aws_elastic_beanstalk_environment" "bstk_env" {
  name = "${var.app_name}-${var.environment}"
  application = "${aws_elastic_beanstalk_application.bstk_app.name}"

  solution_stack_name = "64bit Amazon Linux 2016.03 v2.1.0 running Docker 1.9.1"

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = "${var.vpc_id}"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name = "Subnets"
    value = "${join(",",var.instance_subnet_ids)}"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name = "ELBSubnets"
    value = "${join(",",var.elb_subnet_ids)}"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name = "AssociatePublicIpAddress"
    value = "false"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name = "ELBScheme"
    value = "internal"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application"
    name = "Application Healthcheck URL"
    value = "${var.healthcheck}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name = "ServiceRole"
    value = "${var.service_role}"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "InstanceType"
    value = "${var.instance_type}"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "EC2KeyName"
    value = "${var.ssh_key}"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "SecurityGroups"
    value = "${var.sg_app_id}"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "SSHSourceRestriction"
    value = "tcp,22,22,127.0.0.1/32"
  }

  setting {
    namespace = "aws:elb:loadbalancer"
    name = "SecurityGroups"
    value = "${var.sg_elb_id}"
  }

  setting {
    namespace = "aws:elb:loadbalancer"
    name = "ManagedSecurityGroup"
    value = "${var.sg_elb_id}"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name = "MaxSize"
    value = "${var.max_size}"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name = "MinSize"
    value = "${var.min_size}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name = "SystemType"
    value = "${var.monitoring_type}"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "IamInstanceProfile"
    value = "${aws_iam_instance_profile.BeanstalkEnhancedHealth.name}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:command"
    name = "BatchSize"
    value = 30
  }

  tags {
    Name = "${var.project}-${var.environment}-${var.app_name}-beanstalk"
    Environment = "${var.environment}"
    Project = "${var.project}"
  }
}
