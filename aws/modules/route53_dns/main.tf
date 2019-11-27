data "aws_route53_zone" "domain" {
  name   = var.domain_name
}

resource "aws_route53_record" "A_record" {
  zone_id = data.aws_route53_zone.domain.zone_id
  name    = "${var.domain_prefix}.${data.aws_route53_zone.domain.name}"
  type    = "A"

  alias {
    name                   = var.elb_dns_name
    zone_id                = var.elb_zone_id
    evaluate_target_health = true
  }
}
