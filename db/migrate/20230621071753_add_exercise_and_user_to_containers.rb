class AddExerciseAndUserToContainers < ActiveRecord::Migration[7.0]
  def change
    add_reference :containers, :exercise, null: true, foreign_key: true
    add_reference :containers, :user, null: false, foreign_key: true
  end
end
