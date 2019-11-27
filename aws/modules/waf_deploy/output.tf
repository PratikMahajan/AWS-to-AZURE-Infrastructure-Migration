output "web_acl_name" {
  value = aws_wafregional_web_acl.wafacl.name
}

output "web_acl_rule" {
  value = aws_wafregional_rule.wafrule.name
}

output "web_acl_ipset" {
  value = aws_wafregional_ipset.wafipset.name
}
