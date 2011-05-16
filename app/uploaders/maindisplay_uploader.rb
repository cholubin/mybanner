# encoding: utf-8

class MaindisplayUploader < CarrierWave::Uploader::Base
include SessionsHelper

  storage :file

      def extension_white_list
        %w(jpg jpeg gif png tif swf)
      end

      def filename
        if original_filename
          file_ext = File.extname(original_filename)
          file_name = Admininfo.first(:order => [:updated_at.desc]).id.to_s

          file_name + file_ext
        end
      end

end
