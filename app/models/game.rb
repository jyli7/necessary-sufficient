class Game < ActiveRecord::Base
	has_many :inputs, dependent: :destroy

	after_create :create_inputs

	NECESSARY_FREQUENCY = 0.4
	SUFFICIENT_FREQUENCY = 0.2

	def create_inputs
		3.times do 
			Input.create!(game_id: self.id, necessary: (rand < NECESSARY_FREQUENCY), sufficient: (rand < SUFFICIENT_FREQUENCY))
		end
	end

	def output_on(input_statuses)
		input_statuses.each_with_index do |input_on, i|
			actual_input = game.inputs[i]
			if actual_input.sufficient && input_on
				return true
			elsif actual_input.necessary && !input_on
				return false
			end
		end
		return game.inputs.keep_if{|i| true }.length >= 2
	end

	def all_evidence
		result = []
	end

end
