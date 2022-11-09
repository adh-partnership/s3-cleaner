#!/bin/sh

set -ex

if [[ -z "$AWS_S3_BUCKET" ]]; then
	echo "AWS_S3_BUCKET is not set."
	exit 1
fi

if [[ -z "$AWS_ACCESS_KEY_ID" ]]; then
	echo "AWS_ACCESS_KEY_ID is not set."
	exit 1
fi

if [[ -z "$AWS_SECRET_ACCESS_KEY" ]]; then
	echo "AWS_SECRET_ACCESS_KEY is not set."
	exit 1
fi

if [[ -z "$AWS_REGION" ]]; then
	echo "AWS_REGION not set, defaulting to us-east-1"
	AWS_REGION="us-east-1"
fi

if [[ -z "$OLDER_THAN" ]]; then
	echo "OLDER_THAN not set, defaulting to 30 days"
	OLDER_THAN=30
fi

if [[ -n "$AWS_S3_ENDPOINT" ]]; then
	APPEND="--endpoint-url $AWS_S3_ENDPOINT"
fi

aws configure --profile s3-cleaner <<-EOF >/dev/null 2>&1
	${AWS_ACCESS_KEY_ID}
	${AWS_SECRET_ACCESS_KEY}
	${AWS_REGION}
	text
EOF

aws s3 ls s3://${AWS_S3_BUCKET} --profile s3-cleaner ${APPEND} | while read -r line; do
	createDate=`echo $line | awk '{print $1" "$2}'`
	createDate=`date -d"$createDate" +%s`
	olderDate=`date --date "$OLDER_THAN days ago" +%s`
	if [[ $createDate -lt $olderDate ]]; then
		file=`echo $line | awk '{print $4}'`
		echo "Deleting $file"
		aws s3 rm s3://${AWS_S3_BUCKET}/${file} --profile s3-cleaner ${APPEND}
	fi
done

aws configure --profile s3-cleaner <<-EOF >/dev/null 2>&1
	null
	null
	null
	text
EOF