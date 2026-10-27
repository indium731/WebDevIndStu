[
  ["Stardew Valley", "Simulation", 2016],
  ["Hollow Knight", "Adventure", 2017],
  ["Baldur's Gate 3", "RPG", 2023],
  ["Hades", "Action", 2020]
].each do |title, genre, year|
  Game.find_or_create_by!(title: title) do |game|
    game.genre = genre
    game.release_year = year
  end
end
