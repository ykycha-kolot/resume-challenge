resource "aws_s3_bucket" "resume_bucket_tf" {
  bucket = "resume-bucket-tf" # Ensure this bucket name is globally unique

}

resource "aws_s3_bucket_ownership_controls" "ownership_controls" {
  bucket = aws_s3_bucket.resume_bucket_tf.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "public_aceess_block" {
  bucket              = aws_s3_bucket.resume_bucket_tf.id
  block_public_policy = false
}

resource "aws_s3_bucket_website_configuration" "resume_website" {
  bucket = aws_s3_bucket.resume_bucket_tf.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}
resource "aws_s3_bucket_policy" "resume_bucket_policy" {
  bucket = aws_s3_bucket.resume_bucket_tf.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicRead"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.resume_bucket_tf.arn}/*"
      }
    ]
  })
}

resource "aws_s3_object" "dist" {
  bucket       = aws_s3_bucket.resume_bucket_tf.id
  for_each     = fileset("${path.module}/../website/", "**/**")
  key          = each.value
  source       = "${path.module}/../website/${each.value}"
  content_type = lookup(local.content_types, basename(each.key), "text/html")
}

output "domain_name" {
  value = aws_s3_bucket_website_configuration.resume_website.website_endpoint

}
