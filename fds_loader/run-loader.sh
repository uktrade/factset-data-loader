#!/usr/bin/env bash
# TODO: If we can't get aut working we may need to copy the key, data db and xml config from s3

# Set the data loader credentials
sed -i -e "s/<serial><\/serial>/<serial>$FACTSET_DEVICE_SERIAL<\/serial>/g" /fds_loader/config.xml
sed -i -e "s/<user><\/user>/<user>$FACTSET_USER<\/user>/g" /fds_loader/config.xml

# Pull key from s3
aws s3 cp s3://$S3_OUTPUT_BUCKET/key.txt /fds_loader

# Run the loader script
/fds_loader/FDSLoader64 --bundle $FACTSET_BUNDLES

# Copy key back to s3
aws s3 cp /fds_loader/key.txt s3://$S3_OUTPUT_BUCKET

# Copy downloaded files to s3 (uses minio if local endpoint is set)
if [[ -z "${S3_LOCAL_ENDPOINT_URL}" ]]; then
  aws s3 cp /data/zips "s3://$S3_OUTPUT_BUCKET$S3_OUTPUT_PREFIX" --recursive
else
  aws --endpoint-url $S3_LOCAL_ENDPOINT_URL s3 cp /data/zips "s3://$S3_OUTPUT_BUCKET$S3_OUTPUT_PREFIX" --recursive
fi
