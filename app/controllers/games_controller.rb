class GamesController < ApplicationController
  def index
  end

  def create
  end

  def show
  end

  def answer
  	@game = Game.find(params[:id])
  	@is_correct = true
  	@game.inputs.each_with_index do |input, i|
  		if input.necessary && params[:game][:inputs_attributes][i.to_s][:necessary] != "1"
  			@is_correct = false
  			break
  		elsif input.sufficient && params[:game][:inputs_attributes][i.to_s][:sufficient] != "1"
  			@is_correct = false
  			break
  		end
  	end
  	@is_correct

  	@evidence_sets = @game.random_subset_of_evidence_with_result
  end
end
