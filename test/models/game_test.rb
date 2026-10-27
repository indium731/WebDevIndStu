require "test_helper"

class GameTest < ActiveSupport::TestCase
  test "normalizes text and rejects case insensitive duplicate titles" do
    game = Game.create!(title: "  Hades  ", genre: " Action ", release_year: 2020)
    assert_equal "Hades", game.title
    assert_equal "Action", game.genre
    duplicate = Game.new(title: "hades", genre: "RPG", release_year: 2020)
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:title], "has already been taken"
  end

  test "requires text and an integer year in the original domain range" do
    game = Game.new(title: " ", genre: " ", release_year: 1969)
    assert_not game.valid?
    assert game.errors[:title].any?
    assert game.errors[:genre].any?
    assert game.errors[:release_year].any?
    game.assign_attributes(title: "a" * 121, genre: "b" * 41, release_year: 2101)
    assert_not game.valid?
    assert game.errors[:title].any?
    assert game.errors[:genre].any?
    game.assign_attributes(title: "Test", genre: "Action", release_year: 2020.5)
    assert_not game.valid?
    [1970, 2100].each do |year|
      game.release_year = year
      assert game.valid?
    end
  end
end
