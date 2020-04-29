class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes do |t|
      t.integer :points
      t.references :movie_still, foreign_key: true
      t.references :player, foreign_key: true

      t.timestamps
    end
  end
end
