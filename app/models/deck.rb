class Deck < ActiveRecord::Base
  has_many :deck_listings
  has_many :cards, through: :deck_listings
end