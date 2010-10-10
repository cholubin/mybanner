require 'yaml'
PAYGATE_CONFIG = YAML.load_file(File.join(Rails.root, "config", "paygate_setting.yml"))[RAILS_ENV]  
