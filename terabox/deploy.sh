#!/bin/bash
echo -e "To run please prepare:\n  aws_access_key: KS2S2F4F2F2\n  aws_secret_key: M3C9S8D2...\n  aws_region: eu-west-1\n  aws_ami: ami-05f7491af5eef733a\n  ssh_public_key_path: ~/.ssh/id_rsa.pub\n  ssh_key_name: My Default Key\n  IP Addr: 123.123.123.123\n  Explorer URL: tdexd variable\n  S3 bucket name: or replace tdexdb in backup.sh"

echo "Please enter your parameters"
read -p "AWS Access Key: " AWS_ACCESS_KEY
read -p "AWS Secret Access Key: " AWS_SECRET_ACCESS_KEY
read -p "AWS Region: " AWS_REGION
read -p "AWS AMI ID: " AWS_AMI
read -p "AWS S3 bucket name: " AWS_S3
read -p "SSH Pubic key path: " SSH_PUB_KEY
read -p "SSH Key Name: " SSH_KEY
read -p "Your IP address: " IP_ADDR
read -p "Explorer URL: " EXPLORER_URL

cat vrs.cnf > variables.tf
sed -i "s/AWSKEY/$AWS_ACCESS_KEY/g" ./scripts/backup.sh
sed -i "s/AWSSECRET/$AWS_SECRET_ACCESS_KEY/g" ./scripts/backup.sh
sed -i "s/tdexdb/$AWS_S3/g" ./scripts/backup.sh
sed -i "s/REGION/$AWS_REGION/g" variables.tf
sed -i "s/AMI_ID/$AWS_AMI/g" variables.tf
sed -i "s/222.222.222.222/$IP_ADDR/g" main.tf
EXPL="$EXPLORER_URL"
sed -i "s,EXPLR,$EXPL,g" ./scripts/provisioner.sh

planName="terabox_plan"
/usr/local/bin/terraform init
/usr/local/bin/terraform plan -input=false -var=aws_access_key=\"$AWS_ACCESS_KEY\" -var=aws_secret_key=\"$AWS_SECRET_ACCESS_KEY\" -var=public_key_path=$SSH_PUB_KEY -var=key_name=$SSH_KEY -out $planName
/usr/local/bin/terraform apply $planName
