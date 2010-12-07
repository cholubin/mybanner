# encoding: utf-8

class LogoUploader < CarrierWave::Uploader::Base
include SessionsHelper

  storage :file

      def extension_white_list
        %w(jpg jpeg gif png tif)
      end

      def filename
        if original_filename
          file_ext = File.extname(original_filename)
          "logo" + file_ext
          
        end
      end

end
