# Questa classe descrive l'entità Quiz e le sue validazioni e operazioni.

class Quiz < ActiveRecord::Base  
  
  #Variabili di classe per la gestione degli errori.
  @@error_message = ""
  
  # Validazioni sulle proprietà del Model.
  validates :level, presence: true,
					numericality: { only_integer: true,
									greater_than: 0,
									less_than_or_equal_to: 3
								  }
    
  validate :uniqueness_quiz_validator  
  
  # Associazioni con le altre entità dell'ORM, quali
  # le righe del quiz e gli animali. L'ultima riga consente
  # l'inserimento degli attributi dell'entità QuizRow. Inoltre
  # con l'eliminazione di un Quiz è prevista anche l'eliminazione
  # delle QuizRow associate.
  
  has_many :quiz_rows, dependent: :destroy
  has_many :animals, through: :quiz_rows
  accepts_nested_attributes_for :quiz_rows
  
  # ------Metodi -------------------------------------------------------------------
  
  # Metodi pubblici per la gestione dei quiz.

  # Verify_presence_of_quizzes: ritorna un messaggio di errore
  # (stampato poi nella view), se non sono presenti quiz nel DB.
  
  def self.verify_presence_of_quizzes		
	  if !Quiz.any?			
		  @@error_message = "Nessun quiz trovato."
	  else			
		  @@error_message = ""
	  end		
  end

  # Metodo per accedere alla variabile di classe error_message.
  
  def self.error_message
	@@error_message
  end
	  
  # Prepare_quiz (animal_ids) : questo metodo setta nelle rispettive
  # Quiz Rows i corretti animal_id.
	  
  def prepare_quiz(animal_ids)		
	  # setta i valori corretti per le righe del quiz: quiz_id e animal_id.
	  i = 0
	  self.quiz_rows.each do |row|
		  row.animal_id = animal_ids[i]
		  i += 1
	  end
  end
  
  # Metodi pubblici per la partita.
  
  # Random_animal: ritorna un animale a caso.
  
  def random_animal
	  animals.sample
  end
  
  # Get_animals_from_id: ritorna g++li animali appartenenti al quiz con l'id passato come parametro.
  
  def self.get_animals_from_id(idquiz)
	  animal1 = find(idquiz).animals.first
	  animal2 = find(idquiz).animals.last
	  return animal1,animal2
  end

  # Random_quiz_array: ritorna un array composto da numQuiz Quiz,un array di animali dei quiz
  # e un array con le risposte esatte. Se numQuiz vale 0 allora si ritornano un array standard
  # con 4 quiz di livello 1, 4 di livello 2 e 2 di livello 3, con gli animali e le risposte.
  
  def self.random_quiz_array(numQuiz,livello,standard)
	if(standard == "no")
	  livelloQuiz = livello.to_i
	  if (livelloQuiz == 0)
		quizzes = self.all.includes(:quiz_rows, :animals)
	  else
		quizzes = self.where(:level => livelloQuiz).includes(:quiz_rows, :animals)
	  end
	  quiz_arr = []
	  animal_arr = []
	  solution_arr = []
	  numQuiz.to_i.times do
		  q1 = quizzes.sample
		  quiz_arr.push(q1)
		  animal_arr.push(q1.animals)
		  solution_arr.push(q1.random_animal.cry)
		  quizzes.delete_if {|q| q == q1}		
	  end
	  return quiz_arr, animal_arr, solution_arr
	else
	  ar1 = self.where(:level => 1).includes(:quiz_rows, :animals).sample(4)
	  ar2 = self.where(:level => 2).includes(:quiz_rows, :animals).sample(4)
	  ar3 = self.where(:level => 3).includes(:quiz_rows, :animals).sample(2)
	  quiz_arr = ar1 + ar2 + ar3
	  animal_arr = []
	  solution_arr = []
	  10.times do |i|
		animal_arr.push(quiz_arr[i].animals)
		solution_arr.push(quiz_arr[i].random_animal.cry)
	  end
	  return quiz_arr, animal_arr, solution_arr
	end
  end
  
  # Levels_hash : la funzione restituisce il livello più alto tra i quiz presenti
  # nel DB e un hash contenente l'associazione livello -> numero quiz di quel livello.
  
  def self.levels_hash
	quizzes = self.all.to_a
	quiz_count = quizzes.length
	level_arr = []
	highest_level = 1
	quizzes.each do |quiz|
	  level_arr.push(quiz.level)
	  if quiz.level > highest_level
		highest_level = quiz.level
	  end
	end
	level_count = Hash[level_arr.group_by{|i| i }.map{|k,v| [k,v.size]}]
	return highest_level, level_count, quiz_count
  end
  
  # Metodi privati
  
  private
  
  # Uniqueness_quiz_validator: Gestisce la validazione di unicità del Quiz. L'utente non può creare due quiz
  # aventi gli stessi animali.
  
  def uniqueness_quiz_validator
	first_animal_id = self.quiz_rows.first.animal_id
	second_animal_id = self.quiz_rows.last.animal_id
	if QuizRow.select("quiz_id, count(*)").where(animal_id: [ first_animal_id, second_animal_id ]).group(:quiz_id).having("count(*) > ?", 1).any?
		self.errors[:base] << "Esiste già un quiz con gli animali scelti!"
	end
  end
end
