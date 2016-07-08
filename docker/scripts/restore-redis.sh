#!/bin/sh
set -e

backup_file=$1

backups_dir=/backups
log_file=${backups_dir}/backups.log
restore_dir=${backups_dir}/restore

rm -rf ${restore_dir}
mkdir -p ${restore_dir}
cd ${restore_dir}

if [ -z "$backup_file" ]; then
  echo "You must provide the name of the backup file to retrieve from S3."

  echo "$(date): could not restore redis: missing backup file" >> ${log_file}
  exit 1
fi

if [ -z "$AWS_ACCESS_KEY_ID" ] || [ -z "$AWS_SECRET_ACCESS_KEY" ] || [ -z "$AWS_DEFAULT_REGION" ] || [ -z "$S3_BACKUPS_BUCKET" ]; then
  echo "$(date): could not restore redis: missing environment variables" >> ${log_file}
  exit 1
fi

echo "$(date): starting redis restoration" >> ${log_file}

aws s3 cp s3://${S3_BACKUPS_BUCKET}/${backup_file} ${backup_file}
gzip -dc ${backup_file} > /data/dump.rdb

echo "$(date): redis restoration finished" >> ${log_file}