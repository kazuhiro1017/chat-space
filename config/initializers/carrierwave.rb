require 'carrierwave/storage/file'
require 'carrierwave/storage/fog'

CarrierWave.configure do |config|
  config.storage = :fog
  config.fog_provider = 'fog/aws'
  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: Rails.application.secrets.aws_access_key_id,
    aws_secret_access_key: Rails.application.secrets.aws_secret_access_key,
    region: 'ap-northeast-1' #例 'ap-northeast-1'     他のリージョンを設定した場合、別途調べる必要があります。
  }

  config.fog_directory  = 'kazuhiroimagebucket'
  config.asset_host = 'https://s3-ap-northeast-1.amazonaws.com/kazuhiroimagebucket'    #例  'https://s3-ここにリージョン名を入れます(※例 ap-northeast-1).amazonaws.com/ここにバケット名を入れます'
end