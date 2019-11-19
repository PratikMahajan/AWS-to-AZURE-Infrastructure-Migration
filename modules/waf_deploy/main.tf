resource "aws_wafregional_ipset" "wafipset" {
  name = "tfipset"

  ip_set_descriptor {
    type  = "IPV4"
    value = "127.0.0.1/32"
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

resource "aws_wafregional_sql_injection_match_set" "sql_injection_match_set" {
  name = "SqlInjection"

  sql_injection_match_tuple {
    text_transformation = "URL_DECODE"

    field_to_match {
      type = "QUERY_STRING"
    }
  }
}

resource "aws_wafregional_rule" "wafrule" {
  name        = "Rule1"
  metric_name = "Rule1"

  predicate {
    data_id = "${aws_wafregional_ipset.wafipset.id}"
    negated = false
    type    = "IPMatch"
  }
}

resource "aws_wafregional_rule" "wafrule2" {
  name	   = "Rule2"
  metric_name   = "Rule2"

  predicate {
    data_id = "${aws_wafregional_size_constraint_set.size_constraint_set.id}"
    negated = false
    type    = "SizeConstraint"
  }

}

resource "aws_wafregional_rule" "wafrule3" {
  name     = "Rule3"
  metric_name   = "Rule3"

  predicate {
    data_id = "${aws_wafregional_sql_injection_match_set.sql_injection_match_set.id}"
    negated = false
    type    = "SqlInjectionMatch"
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
