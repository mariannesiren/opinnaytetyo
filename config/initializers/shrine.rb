require "shrine/storage/s3"

s3_options = {
  access_key_id:     ENV["S3_ACCESS_KEY_ID"],
  secret_access_key: ENV["S3_SECRET_ACCESS_KEY"],
  region:            ENV["S3_REGION"],
  bucket:            ENV["S3_BUCKET"],
}

Shrine.storages = {
  cache: Shrine::Storage::S3.new(prefix: "cache", **s3_options),
  store: Shrine::Storage::S3.new(prefix: "store", **s3_options)
}

Shrine.plugin :presign_endpoint
Shrine.plugin :activerecord
