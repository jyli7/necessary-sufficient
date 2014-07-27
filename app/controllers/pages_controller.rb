class PagesController < ApplicationController
  def home
  	@game = Game.create!
  end
end
