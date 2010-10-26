class MyimageUploader < CarrierWave::Uploader::Base

  storage :file

  def extension_white_list
      %w(jpg jpeg gif png pdf eps tif)
  end

  def filename

    if original_filename # 이미지파일을 업로드 한 경우에만 적용 
      @file_ext_name = File.extname(original_filename).downcase
      @temp_filename = model.id.to_s + @file_ext_name
    end

  end

end
