#!/bin/sh
set -e

backups_dir=/backups
log_file=${backups_dir}/backups.log
week_day=$(date +%A)
backup_file=db_dump_${week_day}.gz

mkdir -p ${backups_dir}
cd ${backups_dir}

if [ -z "$AWS_ACCESS_KEY_ID" ] || [ -z "$AWS_SECRET_ACCESS_KEY" ] || [ -z "$AWS_DEFAULT_REGION" ] || [ -z "$S3_BACKUPS_BUCKET" ]; then
  echo "$(date): could not backup db: missing environment variables" >> ${log_file}
  exit 1
fi

echo "$(date): starting db backup" >> ${log_file}

pg_dumpall -c -U postgres | gzip > ${backup_file}
aws s3 cp ${backup_file} s3://${S3_BACKUPS_BUCKET}/

echo "$(date): db backup finished" >> ${log_file}