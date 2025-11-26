module "s3_logs" {
  source = "./S3-LOGS"

}


module "vpc-db" {
  source = "./VPC-DB"

  flowlogs_s3_arn = module.s3_logs.flowlogs_s3_arn

}

module "vpc-app" {
  source = "./VPC-APP"

  flowlogs_s3_arn = module.s3_logs.flowlogs_s3_arn

}

module "vpc-peering" {
  source = "./VPC-PEERING"

  vpc_prod_app_id = module.vpc-app.vpc_id
  vpc_prod_db_id  = module.vpc-db.vpc_id

}