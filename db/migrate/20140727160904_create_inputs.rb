class CreateInputs < ActiveRecord::Migration
  def change
    create_table :inputs do |t|
      t.boolean :necessary
      t.boolean :sufficient

      t.timestamps
    end
  end
end
