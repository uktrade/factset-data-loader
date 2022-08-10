#!/usr/bin/env bash

# TODO: If we can't get aut working we may need to copy the key, data db and xml config from s3

# Set the data loader credentials
sed -i -e "s/<serial><\/serial>/<serial>$FACTSET_DEVICE_SERIAL<\/serial>/g" /fds_loader/config.xml
sed -i -e "s/<user><\/user>/<user>$FACTSET_USER<\/user>/g" /fds_loader/config.xml

# Run the loader script
/fds_loader/FDSLoader64 --bundle $FACTSET_BUNDLES

# Copy downloaded files to s3 (uses minio if local endpoint is set)
if [[ -z "${S3_LOCAL_ENDPOINT_URL}" ]]; then
  aws s3 cp /data/zips "s3://$S3_OUTPUT_BUCKET$S3_OUTPUT_PREFIX" --recursive
else
  aws --endpoint-url $S3_LOCAL_ENDPOINT_URL s3 cp /data/zips "s3://$S3_OUTPUT_BUCKET$S3_OUTPUT_PREFIX" --recursive
fi
