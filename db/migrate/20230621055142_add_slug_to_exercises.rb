class AddSlugToExercises < ActiveRecord::Migration[7.0]
  def change
    add_column :exercises, :slug, :string
    add_index :exercises, :slug, unique: true
  end
end
