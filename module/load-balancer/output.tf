output "lb" {
  value = aws_lb.flex-lb.dns_name
}

output "tg-arn" {
  value = aws_lb_target_group.flex-tg.arn
}

output "zone_id" {
  value = aws_lb.flex-lb.zone_id
}