class CreateGames < ActiveRecord::Migration[8.1]
  def change
    create_table :games do |t|
      t.string :title, null: false, limit: 120, collation: "NOCASE"
      t.string :genre, null: false, limit: 40
      t.integer :release_year, null: false
      t.timestamps
    end
    add_index :games, :title, unique: true
    add_check_constraint :games, "release_year BETWEEN 1970 AND 2100", name: "games_release_year_range"
  end
end
