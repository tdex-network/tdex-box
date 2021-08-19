#!/bin/bash
x=$(echo "$@" | awk '{print NF}')
if [[ ! x -eq 9 ]] ; then
echo -e "To run please prepare:\n  aws_access_key: KS2S2F4F2F2\n  aws_secret_key: M3C9S8D2...\n  aws_region: eu-west-1\n  aws_ami: ami-05f7491af5eef733a\n  ssh_public_key_path: ~/.ssh/id_rsa.pub\n  ssh_key_name: My Default Key\n  IP Addr: 123.123.123.123\n  Explorer URL: tdexd variable\n  S3 bucket name: or replace tdexdb in backup.sh"
echo -e "\n Example: ./deploy.sh aws_access_key aws_secret_key aws_region aws_ami ssh_public_key_path ssh_key_name IP_ADDR https://explr.url/ aws_s3_BucketName"
exit 1
fi
sed -i "s/AWSKEY/$1/g" ./scripts/backup.sh
sed -i "s/AWSSECRET/$2/g" ./scripts/backup.sh
sed -i "s/tdexdb/$9/g" ./scripts/backup.sh
sed -i "s/REGION/$3/g" variables.tf
sed -i "s/AMI_ID/$4/g" variables.tf
sed -i "s/222.222.222.222/$7\/32/g" main.tf
EXPL="$8"
sed -i "s,EXPLR,$EXPL,g" ./scripts/provisioner.sh

planName="terabox_plan"
/usr/local/bin/terraform init
/usr/local/bin/terraform plan -input=false -var=aws_access_key=\"$1\" -var=aws_secret_key=\"$2\" -var=public_key_path=$5 -var=key_name=$6 -out $planName
/usr/local/bin/terraform apply $planName
