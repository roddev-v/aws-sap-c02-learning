# CloudFront Exam Practice Topics

This list contains bite-sized hands-on exercises for AWS Solutions Architect – Professional exam preparation using CloudFront.

## 1. Origins & Origin Access
- [x] S3 as origin - static website distribution
- [x] API Gateway + Lambda as origin
- [ ] Custom origin (EC2/ALB)
- [ ] Origin Access Identity (OAI) vs Origin Access Control (OAC)

## 2. Behaviors & Path Patterns
- [x] Multiple cache behaviors per distribution
- [x] Path patterns (e.g., `/static/*`, `/api/*`)
- [x] Default behavior vs specific behaviors
- Viewer protocol policy (HTTP → HTTPS)

## 3. Caching & TTL
- Cache based on query strings, headers, cookies
- Min / max / default TTLs
- Invalidation requests (manual and programmatic)
- Cache policies (Managed vs Custom)

## 4. Custom Domains & Certificates
- Alternate domain names (CNAMEs)
- ACM certificates (us-east-1)
- Route53 integration (alias records)

## 5. Security & Access
- AWS WAF integration
- Signed URLs / Signed cookies
- Restrict access to S3 (private content)
- Viewer protocol policy (HTTPS only)

## 6. Logging & Monitoring
- CloudFront access logs (S3 destination)
- CloudWatch metrics for distributions
- Alarms for 4xx/5xx errors

## 7. Edge Computing
- Lambda@Edge / CloudFront Functions
- Modifying headers, redirects, authentication at edge

## 8. Integration Patterns
[x] CloudFront + S3 (static site)
[x] CloudFront + API Gateway (serverless backend)
- Mixed distributions (static + dynamic paths)
- Path-based TTL and caching

## Study Strategy
1. Pick one topic → implement a mini Terraform project
2. Test changes live → observe caching, TTL, headers
3. Add complexity gradually (e.g., WAF → Lambda@Edge)
4. Keep a cheat sheet mapping topic → Terraform resource → exam question type
