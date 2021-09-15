#!/bin/bash

echo "Please enter your parameters"
read -p "AWS Access Key: (eg. KS2S2F4F2F2): " AWS_ACCESS_KEY
read -p "AWS Secret Access Key: (eg. M3C9S8D2...): " AWS_SECRET_ACCESS_KEY
read -p "AWS Region: (eg. eu-west-1): " AWS_REGION
read -p "AWS AMI ID: (eg. ami-05f7491af5eef733a): " AWS_AMI
read -p "AWS S3 bucket name: (eg. MyBucketName): " AWS_S3
read -p "SSH Pubic key path: (eg. ~/.ssh/id_rsa.pub): " SSH_PUB_KEY
read -p "SSH Key Name: (eg. MyDefaultSshKey): " SSH_KEY
read -p "Your IP address: (eg. 43.34.43.34): " IP_ADDR
read -p "Explorer URL: (eg. https://blockstream.info/liquid/api): " EXPLORER_URL
read -p "Do you want to use TOR?: " yn
case $yn in
    [Yy]* ) sed -i "s/false/true/g" ./scripts/provisioner.sh; read -p "Base64 Onion Key: (eg. caz6f2svrgcem2gnc5): " ONIONKEY; ;;
    [Nn]* ) ;;
    * ) echo "Please answer yes or no.";;
esac
sed -i "s/AWSKEY/$AWS_ACCESS_KEY/g" ./scripts/backup.sh
sed -i "s/AWSSECRET/$AWS_SECRET_ACCESS_KEY/g" ./scripts/backup.sh
sed -i "s/tdexdb/$AWS_S3/g" ./scripts/backup.sh
sed -i "s/REGION/$AWS_REGION/g" variables.tf
sed -i "s/AMI_ID/$AWS_AMI/g" variables.tf
sed -i "s/222.222.222.222/$IP_ADDR/g" main.tf
EXPL="$EXPLORER_URL"
sed -i "s,EXPLR,$EXPL,g" ./scripts/provisioner.sh
sed -i "s,base64PK,$ONIONKEY,g" ./scripts/provisioner.sh

planName="terabox_plan"
/usr/local/bin/terraform init
/usr/local/bin/terraform plan -input=false -var=aws_access_key=\"$AWS_ACCESS_KEY\" -var=aws_secret_key=\"$AWS_SECRET_ACCESS_KEY\" -var=public_key_path=$SSH_PUB_KEY -var=key_name=$SSH_KEY -out $planName
/usr/local/bin/terraform apply $planName
