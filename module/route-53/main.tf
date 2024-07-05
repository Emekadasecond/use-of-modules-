data "aws_route53_zone" "route_53" {
  name         = "emekaweddings.com"
  private_zone = false
}

resource "aws_route53_record" "record" {
  zone_id = data.aws_route53_zone.route_53.zone_id
  name    = "emekaweddings.com"
  type    = "A"
  alias {
    name = var.dns_name
    zone_id = var.zone_id
    evaluate_target_health = false 
  }
}