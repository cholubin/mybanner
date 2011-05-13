# encoding: utf-8

class BannerUploader < CarrierWave::Uploader::Base
include SessionsHelper

  storage :file

    def store_dir   
      dir = "#{RAILS_ROOT}/public/images/admin/banner"
      FileUtils.mkdir_p dir if not File.exist?(dir)
      FileUtils.chmod 0777, dir
      return dir 
      # "#{RAILS_ROOT}/public/user_files/images/"
    end
  
    def extension_white_list
      %w(jpg png swf)
    end

    def filename
    
      if original_filename # 이미지파일을 업로드 한 경우에만 적용 
        @file_ext_name = File.extname(original_filename).downcase
        
        (model.id.to_s + @file_ext_name)
      end
    
    end

end
