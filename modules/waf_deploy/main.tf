resource "aws_wafregional_ipset" "wafipset" {
  name = "tfipset"

  ip_set_descriptor {
    type  = "IPV4"
    value = "192.0.7.0/24"
  }
}

resource "aws_wafregional_size_constraint_set" "size_constraint_set" {
  name = "SizeRule"

  size_constraints {
    text_transformation = "NONE"
    comparison_operator = "GT"
    size                = "20000000"

    field_to_match {
      type = "BODY"
    }
  }
}

resource "aws_wafregional_rule" "wafrule" {
  name        = "MyRule"
  metric_name = "MyRule"

  predicate {
    data_id = "${aws_wafregional_ipset.wafipset.id}"
    negated = false
    type    = "IPMatch"
  }
  
  predicate {
    data_id = "${aws_wafregional_size_constraint_set.size_constraint_set.id}"
    negated = false
    type    = "SizeConstraint"
  }

}

resource "aws_wafregional_web_acl" "wafacl" {
  name        = "MyWebACL"
  metric_name = "MyWebACL"

  default_action {
    type = "ALLOW"
  }

  rule {
    action {
      type = "BLOCK"
    }

    priority = 1
    rule_id  = "${aws_wafregional_rule.wafrule.id}"
    type     = "REGULAR"
  }
}

resource "aws_vpc" "wafvpc" {
  cidr_block = "10.0.0.0/16"
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "wafsub1" {
  vpc_id            = "${aws_vpc.wafvpc.id}"
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
}

resource "aws_subnet" "wafsub2" {
  vpc_id            = "${aws_vpc.wafvpc.id}"
  cidr_block        = "10.0.2.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
}

resource "aws_alb" "wafalb" {
  internal = true
  subnets  = ["${aws_subnet.wafsub1.id}", "${aws_subnet.wafsub2.id}"]
}

resource "aws_wafregional_web_acl_association" "webassociation" {
  resource_arn = "${aws_alb.wafalb.arn}"
  web_acl_id   = "${aws_wafregional_web_acl.wafacl.id}"
}
