locals {
  common_tags = "${map(
                    "Name"  ,   "c-crypt"                                     ,
                    "Owner" ,   "${data.aws_caller_identity.current.arn}:${data.aws_caller_identity.current.user_id}" ,
                  )}"
}
