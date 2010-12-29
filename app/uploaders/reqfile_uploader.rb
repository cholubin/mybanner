# encoding: utf-8

class ReqfileUploader < CarrierWave::Uploader::Base
include SessionsHelper

  # Include RMagick or ImageScience support
  #     include CarrierWave::RMagick
  #     include CarrierWave::ImageScience

  # Choose what kind of storage to use for this uploader
  storage :file
  #     storage :s3

  # Override the directory where uploaded files will be stored
  # This is a sensible default for uploaders that are meant to be mounted:
  # def store_dir
  #   "#{RAILS_ROOT}/public/user_files/#{user.class.to_s.underscore}/#{mounted_as}/#{user.id}"
  #   # "#{RAILS_ROOT}/public/user_files/#{currrent_user.userid}/req_files/"
  # 
  # end

  # Provide a default URL as a default if there hasn't been a file uploaded
  #     def default_url
  #       "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  #     end

  # Process files as they are uploaded.
  #     process :scale => [200, 300]
  #
  #     def scale(width, height)
  #       # do something
  #     end

  # Create different versions of your uploaded files
  #     version :thumb do
  #       process :scale => [50, 50]
  #     end

  # Add a white list of extensions which are allowed to be uploaded,
  # for images you might use something like this:
      def extension_white_list
        %w(jpg jpeg gif png pdf tif psd eps ai zip)
      end

  # Override the filename of the uploaded files
      def filename
        if original_filename
          file_ext = File.extname(original_filename)
          file_name = Jobboard.first(:order => [:updated_at.desc]).id.to_s

          file_name + file_ext
        end
      end

end
