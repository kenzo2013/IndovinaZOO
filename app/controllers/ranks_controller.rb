# RanksController - Controller che gestisce le azioni e le viste
# riguardanti la gestione dei punteggi delle partite. 

class RanksController < ApplicationController
#	make_resourceful do
#		actions :index
#	end 

#	def index
#			@ranks = Rank.top5
#	end

	def top5
			@ranks = Rank.top5
	end

  def create
    @rank = Rank.new(rank_params)

    respond_to do |format|
      if @rank.save
        format.html { redirect_to ranks_top5_path, notice: 'Punteggio inserito in classifica!' }
      else
        format.html { redirect_to result_path, notice: 'Errore punteggio non inserito, riprova' }
      end
    end
  end

	def rank_params
		params.require(:rank).permit(:nickname, :score)
	end

end
