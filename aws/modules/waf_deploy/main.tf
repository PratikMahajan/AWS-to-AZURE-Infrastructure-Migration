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
    data_id = aws_wafregional_ipset.wafipset.id
    negated = false
    type    = "IPMatch"
  }
}

resource "aws_wafregional_rule" "wafrule2" {
  name	   = "Rule2"
  metric_name   = "Rule2"

  predicate {
    data_id = aws_wafregional_size_constraint_set.size_constraint_set.id
    negated = false
    type    = "SizeConstraint"
  }

}

resource "aws_wafregional_rule" "wafrule3" {
  name     = "Rule3"
  metric_name   = "Rule3"

  predicate {
    data_id = aws_wafregional_sql_injection_match_set.sql_injection_match_set.id
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
    rule_id  = aws_wafregional_rule.wafrule.id
    type     = "REGULAR"
  }
}


resource "aws_wafregional_web_acl_association" "webassociation" {
  resource_arn = var.loadbalancer_arn
  web_acl_id   = aws_wafregional_web_acl.wafacl.id
}
