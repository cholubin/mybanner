# encoding: utf-8

class IntroUploader < CarrierWave::Uploader::Base
include SessionsHelper

  storage :file

      def extension_white_list
        %w(jpg)
      end

      def filename
        if original_filename
          file_ext = File.extname(original_filename)
          "intro" + ".jpg"
        end
      end

end
