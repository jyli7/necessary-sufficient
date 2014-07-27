class PagesController < ApplicationController
  def home
  	@game = Game.create!
  	@evidence_sets = @game.random_subset_of_evidence_with_result
  end
end
