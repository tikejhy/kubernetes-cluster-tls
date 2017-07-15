# Create an IAM role for the Web Servers.
resource "aws_iam_role" "master_iam_role" {
    name = "master_iam_role"
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

resource "aws_iam_instance_profile" "master_instance_profile" {
    name = "master_instance_profile"
    role = "master_iam_role"
}

resource "aws_iam_role_policy" "master_iam_role_policy" {
  name = "master_iam_role_policy"
  role = "${aws_iam_role.master_iam_role.id}"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "iam:DeleteServerCertificate",
                "iam:UploadServerCertificate",
                "iam:ListServerCertificates",
                "iam:GetServerCertificate"
            ],
            "Resource": "*"
        },
	{
            "Effect": "Allow",
            "Action": [
		"route53:ChangeResourceRecordSets",
        	"route53:ListHostedZones",
        	"route53:GetHostedZone",
		"route53:ListResourceRecordSets",
		"route53:GetChange"
            ],
            "Resource": "*"
        },
	{
		"Effect": "Allow",
            "Action": [
                "elasticloadbalancing:CreateListener",
                "elasticloadbalancing:DeleteListener",
                "elasticloadbalancing:DescribeInstanceHealth",
                "elasticloadbalancing:DescribeListeners",
                "elasticloadbalancing:DescribeLoadBalancerAttributes",
                "elasticloadbalancing:DescribeLoadBalancerPolicyTypes",
                "elasticloadbalancing:DescribeLoadBalancerPolicies",
                "elasticloadbalancing:DescribeLoadBalancers",
                "elasticloadbalancing:DescribeRules",
                "elasticloadbalancing:DescribeSSLPolicies",
                "elasticloadbalancing:DescribeTags",
                "elasticloadbalancing:DescribeTargetGroupAttributes",
                "elasticloadbalancing:DescribeTargetGroups",
                "elasticloadbalancing:DescribeTargetHealth",
                "elasticloadbalancing:ModifyListener",
                "elasticloadbalancing:SetLoadBalancerListenerSSLCertificate",
                "elasticloadbalancing:SetLoadBalancerPoliciesForBackendServer",
                "elasticloadbalancing:CreateLoadBalancerListeners",
		"elasticloadbalancing:AttachLoadBalancerToSubnets",
	        "elasticloadbalancing:DeleteLoadBalancerListeners",	
		"elasticloadbalancing:ModifyLoadBalancerAttributes",
		"elasticloadbalancing:CreateLoadBalancerPolicy",
 		"elasticloadbalancing:ConfigureHealthCheck",
                "elasticloadbalancing:SetSubnets"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOF
}
