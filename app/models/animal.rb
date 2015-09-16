require 'carrierwave/orm/activerecord'

# Questa classe descrive l'entità Animale e le sue validazioni/operazioni.

class Animal < ActiveRecord::Base
	
	# Variabili di classe per la gestione degli errori.
	
	@@error_message = ""
	
	# Validazioni sulle proprietà del Model.
		
	validates :name, presence: true,
					 length: { maximum: 15 }		
	
	validates :image, presence: true	
	validate :image_size_validation, on: :create
	
	validates :cry, presence: true	
	validate :cryfile_size_validation, on: :create		
	
	before_destroy :has_no_quizzes
	
	mount_uploader :image, AnimalImageUploader
	
	mount_uploader :cry, AnimalCryUploader
	
	# Associazioni con le altre entità dell'ORM.
	
	has_many :quiz_rows
	has_many :quizzes, through: :quiz_rows
		
	# ------- Metodi -----------------------------------------------------------------

    # Metodi pubblici

	# Get_cry: ritorna il path del verso dell'animale passato come parametro.
	  
	def self.get_cry(animal)
		where(name: animal).first.cry
	end
	
	# Verify_presence_of_animals: ritorna un messaggio di errore
    # (stampato poi nella view) se non sono presenti sufficienti animali per creare un quiz.
    
	def self.verify_presence_of_animals				
		if !Animal.any?			
			@@error_message = "Nessun animale trovato."
		else			
			if Animal.count < 2				
				@@error_message = "Crea almeno 2 animali per creare un quiz."
			else
				@@error_message = ""
			end
		end
	end
	
	# Min_animals_to_make_a_quiz: verifica se sono presenti almeno 2 animali per creare un quiz.
	
	def self.min_animals_to_make_a_quiz?
	  if Animal.count >= 2
		true
	  else
		false
	  end
	end
	
	def self.error_message
	  @@error_message
	end
	
	#Metodi privati
		
	private
	
	# Metodi utilizzati per validazioni.

	# Has_no_quizzes: restituisce falso o vero, a seconda che l'animale
	# sia legato o meno a dei quiz. Impedisce l'eliminazione in caso
	# ritorni falso. Mantiene l'integrità della base dati.
	
	def has_no_quizzes
		if self.quizzes.empty?
			return true
		else
			return false
		end
	end
	
	# Image_size_validation: controlla che l'immagine inserita non sia più grande di 5 MB.
    # In caso affermativo, restituisce un errore.

	def image_size_validation
		self.errors[:image] << "Il file deve essere più piccolo di 5 MB." if image.size > 5.megabytes
	end
	
	# Audio_size_validation: controlla che il file audio inserito non sia più grande di 5 MB.
	# In caso affermativo, restituisce un errore.

	def cryfile_size_validation
		self.errors[:cry] << "Il file deve essere più piccolo di 5 MB." if cry.size > 5.megabytes
	end
	
end
