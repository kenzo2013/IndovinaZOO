# SessionsController - Controller personalizzato che eredita dal controller
# Devise le funzionalità di base. Gestisce le viste riguardanti la creazione
# e l'eliminazione di sessioni utente.

class AdminUsers::SessionsController < Devise::SessionsController    
	def home
	end
	
	def create
		super
		flash[:success] = "Login effettuato correttamente."
	end
	
	def destroy
		super
		flash[:success] = "Hai effettuato il logout."
	end	
end

