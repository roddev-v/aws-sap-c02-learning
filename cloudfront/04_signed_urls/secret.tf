resource "aws_secretsmanager_secret" "cloudfront_signed_url_private_key" {
  name = "cloudfront_signed_url_private_key"
}

resource "aws_secretsmanager_secret_version" "private_key_value" {
  secret_id = aws_secretsmanager_secret.cloudfront_signed_url_private_key.id

  secret_string = jsonencode({
    private_key = file("${path.module}/keys/private_key.pem")
    public_key  = file("${path.module}/keys/public_key.pem")
  })
}
