# encoding: utf-8

class BannerUploader < CarrierWave::Uploader::Base
include SessionsHelper

  storage :file

      def extension_white_list
        %w(jpg png)
      end

      def filename
        if original_filename # 이미지파일을 업로드 한 경우에만 적용 
          @file_ext_name = File.extname(original_filename).downcase
          @temp_filename = model.id.to_s + @file_ext_name
        end
      end

end
