class CreateQuizRows < ActiveRecord::Migration
  def change
    create_table :quiz_rows do |t|
      t.integer :quiz_id
      t.integer :animal_id

      t.timestamps
    end
  end
end
