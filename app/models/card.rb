class Card < ActiveRecord::Base
  belongs_to :expansion
  belongs_to :rarity

  has_many :deck_listings
  has_many :decks, through: :deck_listings

  validates :name,      presence: true, uniqueness: true
  validates :expansion, presence: true
  validates :rarity,    presence: true
end