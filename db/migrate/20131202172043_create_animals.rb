class CreateAnimals < ActiveRecord::Migration
  def change
    create_table :animals do |t|
      t.string :name
      t.string :image
      t.string :cry

      t.timestamps
    end
    
    add_index :animals, :name, unique: true
    add_index :animals, :image, unique: true
    add_index :animals, :cry, unique: true 
  end
end
