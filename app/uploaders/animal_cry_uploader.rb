# AnimalCryUploader - Classe che gestisce l'upload di file audio.

class AnimalCryUploader < CarrierWave::Uploader::Base
  after :store, :delete_old_tmp_file
  
  # Specifica il tipo di file utilizzato per l'uploader.  
  storage :file
  
  # Memorizza in cache il nome del tmp file.
  def cache!(new_file)
    super
	@old_tmp_file = new_file
  end
  
  # Cancella il file temporaneo.
  def delete_old_tmp_file(dummy)
	@old_tmp_file.try :delete
  end
  
  # Gestisce il path per la cartella di uploads.
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
  
  # Specifica i formati permessi per l'upload.
  def extension_white_list
    %w(mp3)
  end
  
end
