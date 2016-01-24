class Card < ActiveRecord::Base
  belongs_to :expansion
  belongs_to :rarity

  validates :name,      presence: true, uniqueness: true
  validates :expansion, presence: true
  validates :rarity,    presence: true
end