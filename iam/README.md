# IAM Exam Practice Topics

This list contains bite-sized hands-on exercises for AWS Solutions Architect – Professional exam preparation using IAM and Terraform.

## 1. IAM Roles & Trust Policies
- [ ] Lambda execution role with S3 and DynamoDB access
- [ ] EC2 instance profile with SSM and CloudWatch permissions
- [ ] ECS task role and task execution role
- [ ] Cross-account role for resource access
- [ ] Service-linked roles for AWS services

## 2. IAM Policies & Permissions
- [ ] Custom managed policy with least privilege principle
- [ ] Inline policy vs managed policy comparison
- [ ] Policy with condition keys (IP address, MFA, time-based)
- [ ] Resource-based policy (S3 bucket policy, SNS topic policy)
- [ ] Permission boundaries to limit role permissions

## 3. IAM Users & Groups
- [ ] IAM users with programmatic and console access
- [ ] IAM groups with different permission sets
- [ ] Password policy configuration
- [ ] MFA enforcement for users
- [ ] Access keys rotation strategy

## 4. Cross-Account Access
- [ ] Cross-account IAM role with external ID
- [ ] Resource sharing via RAM (Resource Access Manager)
- [ ] S3 bucket cross-account access
- [ ] Cross-account CloudWatch Logs access
- [ ] Organization SCP (Service Control Policy) examples

## 5. Identity Federation
- [ ] SAML 2.0 identity provider setup
- [ ] Web identity federation with Cognito
- [ ] AssumeRoleWithWebIdentity for mobile apps
- [ ] OIDC provider for GitHub Actions
- [ ] Custom identity broker implementation

## 6. Security & Compliance
- [ ] IAM Access Analyzer configuration
- [ ] CloudTrail logging for IAM events
- [ ] Deny policy for sensitive actions
- [ ] Tag-based access control (ABAC)
- [ ] Session policies for temporary credentials

## 7. Advanced Scenarios
- [ ] Multi-account strategy with AWS Organizations
- [ ] Least privilege policy generator workflow
- [ ] IAM role chaining (assume role from role)
- [ ] VPC endpoint policy for S3/DynamoDB
- [ ] Emergency break-glass access pattern