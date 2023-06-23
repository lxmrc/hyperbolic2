class AddTokenToContainers < ActiveRecord::Migration[7.0]
  def change
    add_column :containers, :token, :string, null: false
  end
end
