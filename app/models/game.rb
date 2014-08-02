class Game < ActiveRecord::Base
	has_many :inputs, dependent: :destroy
	accepts_nested_attributes_for :inputs

	after_create :create_inputs

	NECESSARY_FREQUENCY = 0.5
	SUFFICIENT_FREQUENCY = 0.1
	NUM_INPUTS = 3
	EVIDENCE_FRACTION = 1

	def create_inputs
		NUM_INPUTS.times do 
			Input.create!(game_id: self.id, necessary: (rand < NECESSARY_FREQUENCY), sufficient: (rand < SUFFICIENT_FREQUENCY))
		end

		self.enforce_input_consistency
	end

	def enforce_input_consistency
		if self.inputs.detect{|i| i.sufficient == true}
			self.inputs.map do |i| 
				if i.necessary && !i.sufficient
					i.necessary = false
					i.save
				end
			end
		end
	end

	# How we get from input to output.
	# What happens, when none is necessary, and none is sufficient?
	def output_on(input_statuses)
		input_statuses.each_with_index do |input_on, i|
			actual_input = inputs[i]
			if actual_input.sufficient && input_on
				return true
			elsif actual_input.necessary && !input_on
				return false
			end
		end
		return input_statuses.count{|i| i == true} >= 2
	end

	def all_evidence
		all_results = []
		(0..NUM_INPUTS).each do |i|
			seed_arr = []
			i.times do
				seed_arr.push(false)
			end
			(NUM_INPUTS - i).times do
				seed_arr.push(true)
			end
			all_results.push(seed_arr.permutation.to_a.uniq)
		end
		all_results.flatten(1)
	end

	def random_subset_of_evidence
		all_evidence.sample((all_evidence.length * EVIDENCE_FRACTION).floor)
	end

	def random_subset_of_evidence_with_result
		random_subset_of_evidence.map{|arr| arr + [output_on(arr)]}
	end

end
