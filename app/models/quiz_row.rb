# Classe che descrive l'entità QuizRow, rappresentante una riga
# di un quiz.

class QuizRow < ActiveRecord::Base
	    			
	# Associazioni con altre entità dell'ORM.
	
	belongs_to :animal
	belongs_to :quiz
	
	# Validazioni
	
	validates_presence_of :animal_id
end
