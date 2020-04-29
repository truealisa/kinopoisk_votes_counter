class CreateMovieStills < ActiveRecord::Migration[5.2]
  def change
    create_table :movie_stills do |t|
      t.string :name
      t.string :link
      t.references :player, foreign_key: true

      t.timestamps
    end
  end
end
