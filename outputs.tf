output "region" {
  value = "${var.aws_region}"
}

output "availability_zone" {
  value = "${data.aws_availability_zones.available.names}"
}

output "address" {
  value = "${aws_elb.Infra-Test.dns_name}"
}

output "instance_id" {
  value = "${aws_instance.Infra-Test.id}"
}

output "instance_type" {
  value = "${var.instance_type}"
}

output "vpc_id" {
  value = "${aws_vpc.Infra-Test.id}"
}

output "dhcp_id" {
  value = "${aws_vpc_dhcp_options.DHCP.id}"
}

output "subnet_id" {
  value = "${aws_subnet.Infra-Test.id}"
}

output "route-table" {
  value = "${aws_route_table.Infra-Test.id}"
}

output "ami_id" {
  value = "${aws_instance.Infra-Test.ami}"

}

output "ebs_block_device" {
  value = ["${aws_instance.Infra-Test.ebs_block_device}"]
}

output "ebs_root_device" {
  value = ["${aws_instance.Infra-Test.root_block_device}"]
}

#output "root_device_type" {
#  value = ["${aws_instance.web.root_block_device_type}"]
#}

#output "ebs_volume" {
#  value = ["${aws_instance.web.ebs_volume.id}"]
#}

output "ec2_security_group_id" {
  value = "${aws_security_group.Infra-Test-Ec2.id}"

}

output "ec2_security_group" {
  value = "${aws_security_group.Infra-Test-Ec2.name}"

}

output "elb_security_group_id" {
  value = "${aws_security_group.elb.id}"

}

output "elb_security_group" {
  value = "${aws_security_group.Infra-Test-elb.name}"

}

output "elb_name" {
  value = "${aws_elb.Infra-Test.name}"

}

#output "outputs" {
#value = {
#    "elb_security_group_id" = "${aws_security_group.elb.id}"
#    "elb_security_group" = "${aws_security_group.elb.name}"
#    "elb_name" = "${aws_elb.web.name}"
#  }
#}
