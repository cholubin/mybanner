# encoding: utf-8

class SkinUploader < CarrierWave::Uploader::Base
include SessionsHelper


  storage :file

      def extension_white_list
        %w(jpg)
      end

      def filename
        if original_filename
          "background.jpg"
        end
      end

      def store_dir   
        "#{RAILS_ROOT}" + "/public/images/skin.custom/"
      end
end
