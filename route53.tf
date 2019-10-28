resource "aws_route53_zone" "main" {
  name = "${var.bucket_name}"
}

resource "aws_route53_record" "my_website" {
  zone_id = "${var.route53_zone_id}"
  name    = "${var.bucket_name}"
  type    = "A"

  alias {
    name                   = "${aws_cloudfront_distribution.website_cdn.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.website_cdn.hosted_zone_id}"
    evaluate_target_health = false
  }
}
