module "vpc" {
  source = "./module/vpc"
}

module "rds" {
  source = "./module/rds"
  security_groups = module.security_group.be-sg
  subnet_ids = [module.vpc.priv-1, module.vpc.priv-2]
}

module "security_group" {
  source = "./module/security-group"
  vpc = module.vpc.vpc-id
}

module "load-balancer" {
  source = "./module/load-balancer"
  subnets = [module.vpc.pub-1 , module.vpc.pub-2]
  fe-security_group = [module.security_group.fe-sg]
  vpc-id = module.vpc.vpc-id
}

module "route-53" {
  source = "./module/route-53"
  dns_name = module.load-balancer.lb
  zone_id = module.load-balancer.zone_id
}

module "webserver" {
  source = "./module/webserver"
  key =  module.security_group.pub-key
  fe-sg = [module.security_group.fe-sg]
  vpc_zone_identifiers = [module.vpc.pub-1, module.vpc.pub-2]
  tg-arn = [module.load-balancer.tg-arn]
  db-endpoint = module.rds.db-endpoint
}