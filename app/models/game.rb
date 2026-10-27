class Game < ApplicationRecord
  before_validation :strip_text
  validates :title, presence: true, length: { maximum: 120 }, uniqueness: { case_sensitive: false }
  validates :genre, presence: true, length: { maximum: 40 }
  validates :release_year, numericality: { only_integer: true, greater_than_or_equal_to: 1970, less_than_or_equal_to: 2100 }

  private

  def strip_text
    self.title = title&.strip
    self.genre = genre&.strip
  end
end
