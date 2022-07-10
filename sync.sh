#!/bin/sh

set -e

echo "INFO: Starting sync.sh pid $$ $(date)"

if [ `lsof | grep $0 | wc -l | tr -d ' '` -gt 1 ]
then
  echo "WARNING: A previous sync is still running. Skipping new sync command."
else

  echo $$ > /tmp/sync.pid

  if test "$(rclone ls --max-depth 2 $SYNC_SRC $RCLONE_OPTS)"; then
    # the source directory is not empty
    # it can be synced without clear data loss
    if [ -z "$CHECK_URL" ]
    then
      echo "INFO: Define CHECK_URL with https://healthchecks.io to monitor sync job"
      echo "INFO: Starting rclone sync $SYNC_SRC $SYNC_DEST $RCLONE_OPTS $SYNC_OPTS"
      rclone sync $SYNC_SRC $SYNC_DEST $RCLONE_OPTS $SYNC_OPTS
    else
      # Inform https://healthchecks.io that the job started
      curl \
          --connect-timeout $CURL_TIMEOUT \
          --max-time $CURL_MAXTIME \
          --retry $CURL_RETRIES \
          -qs $CHECK_URL/start
      echo "INFO: Starting rclone sync $SYNC_SRC $SYNC_DEST $RCLONE_OPTS $SYNC_OPTS"
      rclone sync $SYNC_SRC $SYNC_DEST $RCLONE_OPTS $SYNC_OPTS
      # Inform https://healthchecks.io that the job is over
      curl \
          --connect-timeout $CURL_TIMEOUT \
          --max-time $CURL_MAXTIME \
          --retry $CURL_RETRIES \
          -qs $CHECK_URL
    fi
  else
    echo "WARNING: Source directory is empty. Skipping sync command."
  fi

rm -f /tmp/sync.pid

fi
