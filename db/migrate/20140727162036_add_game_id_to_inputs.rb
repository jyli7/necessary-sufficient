class AddGameIdToInputs < ActiveRecord::Migration
  def change
    add_column :inputs, :game_id, :integer
  end
end
