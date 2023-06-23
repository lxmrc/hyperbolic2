class AddSlugToContainers < ActiveRecord::Migration[7.0]
  def change
    add_column :containers, :slug, :string
    add_index :containers, :slug, unique: true
  end
end
