#!/bin/bash
#Please provide the name of your S3 bucket.
cd /home/ubuntu/tdex-box/tdexd/db/ && export AWS_ACCESS_KEY_ID=AWSKEY; export AWS_SECRET_ACCESS_KEY=AWSSECRET; sudo /usr/bin/aws s3 sync . s3://tdexdb/db/