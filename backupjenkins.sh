#!/bin/bash

cd /tmp
rm -rf jenkins_backup
mkdir jenkins_backup
cd jenkins_backup
cp -R $JENKINS_HOME .
date=`date +%Y%m%d`
bucket=$JENKINS_BACKUP_BUCKET
bucket_region=$JENKINS_BACKUP_BUCKET_REGION
file="${date}-jenkinksbackup.tar.gz"
tar czf $file *
resource="/${bucket}/${file}"
contentType="application/x-compressed-tar"
dateValue=`date -R`
stringToSign="PUT\n\n${contentType}\n${dateValue}\n${resource}"
s3Key=$S3_KEY
s3Secret=$S3_SECRET
signature=`echo -en ${stringToSign} | openssl sha1 -hmac ${s3Secret} -binary | base64`
curl -X PUT -T "${file}" \
    -H "Host: ${bucket}.s3-${JENKINS_BACKUP_BUCKET_REGION}.amazonaws.com" \
      -H "Date: ${dateValue}" \
        -H "Content-Type: ${contentType}" \
          -H "Authorization: AWS ${s3Key}:${signature}" \
            https://${bucket}.s3-${JENKINS_BACKUP_BUCKET_REGION}.amazonaws.com/${file}
cd ..
rm -rf /tmp/jenkins_backup
