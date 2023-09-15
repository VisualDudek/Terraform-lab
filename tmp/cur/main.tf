provider "aws" {
    region = "us-east-1"
}

variable "bucket_prefix" {
    type = string
    default = "cur-reports"
    validation {
      condition = can(regex("^[a-z0-9.-]{3,63}$", var.bucket_prefix))
      error_message = "Ivalid s3 prefix name"
    }
}

data "aws_caller_identity" "current" {}

resource "aws_cur_report_definition" "cur_report" {
  report_name                = "bp-cur-report-definition"
  time_unit                  = "HOURLY"
  format                     = "textORcsv"
  compression                = "ZIP"
  additional_schema_elements = ["RESOURCES", "SPLIT_COST_ALLOCATION_DATA"]
  s3_bucket                  = aws_s3_bucket.cur_report.id
  s3_prefix                  = "cur_report/"
  s3_region                  = aws_s3_bucket.cur_report.region
  additional_artifacts       = ["REDSHIFT", "QUICKSIGHT"]
  refresh_closed_reports     = false
  report_versioning          = "CREATE_NEW_REPORT"
}

resource "aws_s3_bucket" "cur_report" {
  bucket_prefix = var.bucket_prefix
}

resource "aws_s3_bucket_versioning" "versioning_cur_report" {
  bucket = aws_s3_bucket.cur_report.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "cur_report_bucket_policy" {
  bucket = aws_s3_bucket.cur_report.id

  policy = <<EOF
     {
        "Version": "2008-10-17",
        "Statement": [
            {
                "Sid": "Stmt1335892150622",
                "Effect": "Allow",
                "Principal": {
                    "Service": "billingreports.amazonaws.com"
                },
                "Action": [
                    "s3:GetBucketAcl",
                    "s3:GetBucketPolicy"
                ],
                "Resource":"arn:aws:s3:::${aws_s3_bucket.cur_report.id}",
                "Condition": {
                    "StringEquals": {
                        "aws:SourceArn": "arn:aws:cur:us-east-1:${data.aws_caller_identity.current.account_id}:definition/*",
                        "aws:SourceAccount": "${data.aws_caller_identity.current.account_id}"
                    }
                }
            },
            {
                "Sid": "Stmt1335892526596",
                "Effect": "Allow",
                "Principal": {
                    "Service": "billingreports.amazonaws.com"
                },
                "Action": "s3:PutObject",
                "Resource": "arn:aws:s3:::${aws_s3_bucket.cur_report.id}/*",
                "Condition": {
                    "StringEquals": {
                        "aws:SourceArn": "arn:aws:cur:us-east-1:${data.aws_caller_identity.current.account_id}:definition/*",
                        "aws:SourceAccount": "${data.aws_caller_identity.current.account_id}"
                    }
                }
            }
        ]
    }
     EOF
}


output "cur_report_s3_bucket" {
  description = "Name of s3 bucket for Cost and Usage Reports"
  value       = aws_s3_bucket.cur_report.bucket_domain_name
}