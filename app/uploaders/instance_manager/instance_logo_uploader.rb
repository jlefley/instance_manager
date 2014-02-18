module InstanceManager
  class InstanceLogoUploader < CarrierWave::Uploader::Base
    storage :file

    def delete_tmp
      FileUtils.rm_rf(File.join(root, cache_dir, cache_id))
      @file = nil
      @cache_id = nil
    end

    def store_dir
      'uploads/logos'
    end

    def extension_white_list
      %w(jpg jpeg gif png)
    end

    def filename
      "#{model.name}.#{file.extension}" if original_filename
    end

  end
end
