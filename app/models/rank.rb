# Classe che descrive l'entità Rank, cioè i punteggi delle partite.

class Rank < ActiveRecord::Base
	
	# Validazioni sulle proprietà del Model.
	
	validates :nickname, presence: true
	validates :score, presence: true,
				      numericality: {greater_than_or_equal_to: 0}


	# Top5: crea la classifica dei primi 5 punteggi.
	
 	def self.top5
		order(:score).reverse_order.first(5)
	end

end
