# QuizzesController - Controller che gestisce le azioni e le viste
# riguardanti per la gestione dei quiz. L'autenticazione è richiesta
# solo per la creazione, la modifica e l'eliminazione di quiz.

class QuizzesController < ApplicationController
	before_action :set_quiz, only: [:show, :edit, :update, :destroy]
	before_action :init_quiz_insertions, only: [:new, :edit]
	before_action :authenticate_admin_user!, except: [:show, :index]

	def index
		Animal.verify_presence_of_animals
		Quiz.verify_presence_of_quizzes
		@quizzes = Quiz.includes(:quiz_rows, :animals)
	end

	def show
	end

	def new
		@quiz = Quiz.new
		2.times { @quiz.quiz_rows.build([quiz_id: @quiz.id]) }
	
		respond_to do |format|
		  format.html { render :layout => !request.xhr? }
		end		
	end

	def create
	
		#Creo l'oggetto quiz.
		@quiz = Quiz.new(quiz_params)
		
		#Preparo l'oggetto quiz con gli id degli animali scelti.				
		@quiz.prepare_quiz([ params[:quiz][:quiz_rows_attributes]["0"][:animal_id], params[:quiz][:quiz_rows_attributes]["1"][:animal_id] ])
					
		if @quiz.save
			flash[:success] = "Quiz creato correttamente!"
			respond_to do |format|
				format.html { redirect_to @quiz }
				format.js
			end
		else
			respond_to do |format|
				format.js { render 'quiz_validation_errors' }
			end
		end
	end

	def edit
		respond_to do |format|
		  format.html { render :layout => !request.xhr? }
		end
	end

	def update	
		if @quiz.update(quiz_params)
			flash[:success] = "Quiz modificato con successo!"
			respond_to do |format|
				format.html { redirect_to @quiz }
				format.js
			end
		else
			respond_to do |format|
				format.js { render 'quiz_validation_errors' }
			end
		end
	end

	def destroy	
		@quiz.destroy
	
		flash[:success] = "Quiz eliminato con successo!"
		
		respond_to do |format|
			format.js
		end
	end

	def set_animal_ids
		@animals = Animal.where.not(id: params[:id]).order(:name)
			
		respond_to do |format|
	      format.js
		end
	end
		
	private
    
    def set_quiz
		@quiz = Quiz.find(params[:id])
	end

	def init_quiz_insertions
		@animals = Animal.order(:name)
	end

	def quiz_params
		params.require(:quiz).permit(:level, quiz_rows_attributes: [:id, :quiz_id, :animal_id])
	end

end
