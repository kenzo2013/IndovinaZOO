class RemoveOldFieldImageFromAnimals < ActiveRecord::Migration
  def change
    remove_column :animals, :image, :string
  end
end
