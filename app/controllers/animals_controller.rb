# AnimalsController - Controller che gestisce le azioni e le viste
# riguardanti la gestione degli animali. L'autenticazione è richiesta
# solo per la creazione, la modifica e l'eliminazione di animali.

class AnimalsController < ApplicationController  
  before_action :set_animal, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_admin_user!, except: [:show, :index]
  
	def new
		@animal = Animal.new
	
		respond_to do |format|
			format.html { render :layout => !request.xhr? }
		end	
	end

	def create		
		@animal = Animal.new(animal_params)
	
		if @animal.save
			flash[:success] = "Animale creato correttamente!"
			respond_to do |format|		 
			  format.js		 
			end
		else
			respond_to do |format|
			  format.js { render 'animal_validation_errors' }
			end
		end
	end

	def show	
	end

	def index
		@animals = Animal.all
		Animal.verify_presence_of_animals
		@animal = Animal.new
	end

	def edit
		respond_to do |format|
		  format.html { render :layout => !request.xhr? }
		end
	end

	def update	
		if @animal.update(animal_params)
			flash[:success] = "Animale modificato correttamente!"
			
			respond_to do |format|
				format.html { redirect_to @animal }
				format.js
			end			
		else
			respond_to do |format|
				format.js { render 'animal_validation_errors' }
			end
		end
	end

	def destroy
	
		# Gestisce i messaggi d'errore in caso la validazione vada a buon fine o meno.
		
		if @animal.destroy
			flash[:success] = "Animale eliminato correttamente!"			
		else
			flash[:error] = "L'animale non può essere eliminato perchè è legato ad almeno 1 quiz."			
		end
		
		redirect_to animals_path		
	end

	private
	
	def set_animal
		@animal = Animal.find(params[:id])
	end
	
	def animal_params
		params.require(:animal).permit(:name, :image, :cry)
	end
end
