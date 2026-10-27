require "test_helper"

class GamesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @game = Game.create!(title: "Hollow Knight", genre: "Adventure", release_year: 2017)
  end

  test "lists games and renders all read and form pages" do
    get root_url
    assert_response :success
    assert_select "h3", "Hollow Knight"
    [game_url(@game), new_game_url, edit_game_url(@game), delete_game_url(@game)].each do |url|
      get url
      assert_response :success
    end
  end

  test "creates updates and deletes a persistent game" do
    assert_difference "Game.count", 1 do
      post games_url, params: { game: { title: "Hades", genre: "Action", release_year: 2020 } }
    end
    game = Game.find_by!(title: "Hades")
    assert_redirected_to game_url(game)
    follow_redirect!
    assert_select "h1", "Hades"
    patch game_url(game), params: { game: { title: "Hades II", release_year: 2025 } }
    assert_redirected_to game_url(game)
    assert_equal "Hades II", game.reload.title
    assert_equal 2025, game.release_year
    assert_difference "Game.count", -1 do
      delete game_url(game)
    end
    assert_redirected_to games_url
  end

  test "invalid submissions show errors without changing stored data" do
    assert_no_difference "Game.count" do
      post games_url, params: { game: { title: "", genre: "Action", release_year: 2020 } }
    end
    assert_response :unprocessable_entity
    assert_select "[role=alert]"
    patch game_url(@game), params: { game: { release_year: 1900 } }
    assert_response :unprocessable_entity
    assert_equal 2017, @game.reload.release_year
  end

  test "delete confirmation does not delete and missing games return 404" do
    assert_no_difference "Game.count" do
      get delete_game_url(@game)
    end
    assert_select "form input[name=_method][value=delete]"
    get game_url(id: 999999)
    assert_response :not_found
  end

  test "renders an empty collection" do
    Game.delete_all
    get games_url
    assert_response :success
    assert_select "h2", "Your next adventure starts here."
  end
end
