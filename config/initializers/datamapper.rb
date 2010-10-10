require "dm-core"
hash = YAML.load(File.new(Rails.root + "config/database.yml"))

DataMapper.setup(:default, hash[Rails.env])
# DataMapper.setup(:default, 'mysql://root:mysql@localhost/kr_address_dev')
DataMapper.logger = Rails.logger