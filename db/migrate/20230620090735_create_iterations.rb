class CreateIterations < ActiveRecord::Migration[7.0]
  def change
    create_table :iterations do |t|
      t.text :code
      t.belongs_to :exercise, null: false, foreign_key: true
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
