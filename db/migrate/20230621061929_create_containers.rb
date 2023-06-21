class CreateContainers < ActiveRecord::Migration[7.0]
  def change
    create_table :containers do |t|
      t.string :docker_id
      t.string :name
      t.string :image

      t.timestamps
    end
  end
end
