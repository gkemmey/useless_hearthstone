class DeckListing < ActiveRecord::Base
  belongs_to :card
  belongs_to :deck
  
  validates :card,  presence: true
  validates :deck,  presence: true
  validates :count, presence: true
end