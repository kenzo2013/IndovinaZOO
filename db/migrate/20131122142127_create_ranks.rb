class CreateRanks < ActiveRecord::Migration
  def change
    create_table :ranks do |t|
      t.string :nickname
      t.integer :score

      t.timestamps
    end
  end
end
