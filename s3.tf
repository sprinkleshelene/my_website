data "template_file" "cloudfront_bucket_policy" {
  template = "${file("policies/cloudfront_bucket_policy.json")}"

  vars {
    origin_access_identity_arn = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  }
}

resource "aws_s3_bucket" "mysite" {
  bucket = "${var.bucket_name}"
  acl    = "public-read"
  policy = "${data.template_file.cloudfront_bucket_policy.rendered}"

  logging {
    target_bucket = "${var.log_bucket_name}"
    target_prefix = "log/"
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Name       = "${var.bucket_name}"
    Automation = "Terraform"
  }

  website {
    index_document = "index.html"
    error_document = "error.html"

    routing_rules = <<EOF
[{
    "Condition": {
        "KeyPrefixEquals": "docs/"
    },
    "Redirect": {
        "ReplaceKeyPrefixWith": "documents/"
    }
}]
EOF
  }
}

resource "aws_s3_bucket" "log_bucket" {
  bucket = "${var.log_bucket_name}"
  acl    = "log-delivery-write"
}
