

title 'two tier setups'

# load data from terraform output
content = inspec.profile.file("terraform.json")
params = JSON.parse(content)

INSTANCE_ID = params['instance_id']['value']
INSTANCE_TYPE = params['instance_type']['value']
AWS_REGION = params['region']['value']
AVAILABILTY_ZONE = params['availability_zone']['value']
DHCP_OPTIONS_ID = params['dhcp_id']['value']
SUBNET_ID = params['subnet_id']['value']
ROUTE_TABLE = params['route-table']['value']
ELB_DNS = params['address']['value']
ELB_NAME = params['elb_name']['value']
VPC_ID = params['vpc_id']['value']
AMI_ID = params['ami_id']['value']
EBS_VOLUME = params['ebs_root_device']['value']
EC2_SECURITY_GROUP = params['ec2_security_group']['value']
EC2_SECURITY_GROUP_ID = params['ec2_security_group_id']['value']
ELB_SECURITY_GROUP = params['elb_security_group']['value']
ELB_SECURITY_GROUP_ID = params['elb_security_group_id']['value']
# execute test

#describe aws_region(AWS_REGION) do
#  it { should exist }
#  its('region_name') { should eq AWS_REGION }
#    its('endpoint') { should eq 'ec2.'(AWS_REGION)'.amazonaws.com' }
#end

describe aws_vpc(VPC_ID) do
 # it { should be_default }
  its ('vpc_id') { should eq VPC_ID }
  its ('instance_tenancy') { should eq 'default' }
  its ('state') { should eq 'available' }
  its('cidr_block') { should cmp '10.0.0.0/16' }
  its ('dhcp_options_id') { should eq DHCP_OPTIONS_ID }

end

describe aws_subnet( SUBNET_ID) do
  it { should exist }
  it { should be_available }
  it { should be_mapping_public_ip_on_launch }
#  it { should be_default_for_az}
#  it { should be_assigning_ipv_6_address_on_creation }
  its('subnet_id') { should eq SUBNET_ID }
  its('vpc_id') { should eq VPC_ID }
  its('cidr_block') { should eq '10.0.1.0/24' }
#  its('availability_zone') { should include AVAILABILITY_ZONE}
  its('available_ip_address_count') { should <251 }
end

describe aws_route_table(ROUTE_TABLE) do
  it { should exist }
  its('route_table_id') {should eq ROUTE_TABLE}
#  its('vpc_id') { should eq VPC_ID }
#  its('routes.count') { should eq 2 }
#  its('associations.count') { should eq 1 }
#  its('propagating_vgws') { should be_empty }

end

describe aws_security_group(group_name: EC2_SECURITY_GROUP , vpc_id: VPC_ID) do
  it { should exist }
  its('group_name') { should eq EC2_SECURITY_GROUP }
  its('description') { should eq 'Used in the terraform' }
  it { should allow_in(port: 22, ipv4_range: '0.0.0.0/0') }
  it { should allow_in(port: 80, ipv4_range: '0.0.0.0/0') }
 # it { should allow_in(port: 8080, ipv4_range: '0.0.0.0/0') }
  it { should allow_out(port: 0, ipv4_range: '0.0.0.0/0') }

  its('inbound_rules') { should be_a_kind_of(Array) }
  its('inbound_rules.first') { should be_a_kind_of(Hash) }
#  its('inbound_rules.count') { should cmp 3 } # 3 explicit, one implicit
  its('inbound_rules_count') { should cmp 2 }
  its('outbound_rules') { should be_a_kind_of(Array) }
  its('outbound_rules.first') { should be_a_kind_of(Hash) }
  its('outbound_rules.count') { should cmp 1 } # 1 explicit
#  its('outbound_rules_count') { should cmp 1 }
#  its('vpc_id') { should eq VPC_ID }
end

describe aws_security_group(group_name: ELB_SECURITY_GROUP , vpc_id:VPC_ID) do
  it { should exist }
  its('group_name') { should eq ELB_SECURITY_GROUP }
  its('description') { should eq 'Used in the terraform' }
#  its('vpc_id') { should eq VPC_ID }
end

describe aws_ec2_instance(INSTANCE_ID) do
  it {should exist}
  it { should be_running }
  it { should_not have_roles }
  its('instance_type'){should eq INSTANCE_TYPE }
#  its('instance_type') { should eq 't2.micro' }
  its('image_id') { should eq AMI_ID }
  its('vpc_id') { should eq VPC_ID }
  its('subnet_id') { should include SUBNET_ID }
  its('security_group_ids') {should include EC2_SECURITY_GROUP_ID}
  its('root_device_type') {should eq 'ebs'}
#  its ()
end

describe aws_ebs_volume(EBS_VOLUME) do
  it { should exist }
#  it { should_not be_encrypted }
#  its ('volume_id') {should eq EBS_VOLUME[{'volume_id'}]}

end
#describe aws_elb(load_balancer_name: ELB_DNS) do
#   it { should exist }
#    its ('load_balancer_name')  { should eq ELB_DNS }
#end


describe aws_elb(ELB_NAME) do
  #its('availability_zones.count') { should be > 1 }
  it { should exist }
#  its('instance_ids.count') { should cmp 2 }
  its('dns_name') { should match /\.com/ }
  its('external_ports') { should include 80 }
  its('external_ports.count') { should cmp 1 }
  its('internal_ports') { should include 80 }
  its('internal_ports.count') { should cmp 1 }
  its('instance_ids') { should include INSTANCE_ID }
  its('vpc_id') { should eq VPC_ID }
  its('subnet_ids') { should include SUBNET_ID }
  its('security_group_ids') { should include ELB_SECURITY_GROUP_ID }
end
