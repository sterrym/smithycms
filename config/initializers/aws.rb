%w(AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_S3_BUCKET).each do |k|
  ENV[k] = Smithy::Setting.find_by_name(k).value if Smithy::Setting.find_by_name(k) && ENV[k].blank?
end
