class GamesController < ApplicationController
  before_action :set_game, only: %i[show edit update delete destroy]

  def index
    @games = Game.order(Arel.sql("LOWER(title) ASC"))
  end

  def show; end

  def new
    @game = Game.new(release_year: Date.current.year)
  end

  def edit; end

  def create
    @game = Game.new(game_params)
    if @game.save
      redirect_to @game, notice: "Game added to your library.", status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @game.update(game_params)
      redirect_to @game, notice: "Game updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def delete; end

  def destroy
    @game.destroy!
    redirect_to games_path, notice: "Game deleted from your library.", status: :see_other
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end

  def game_params
    params.require(:game).permit(:title, :genre, :release_year)
  end
end
