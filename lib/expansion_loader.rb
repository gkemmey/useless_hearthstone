class ExpansionLoader
  class UnknownExpansionError < StandardError
  end
  class UnknownRarityError < StandardError
  end

  def initialize(expansions)
    @expansions = expansions
  end

  def load_cards
    @expansions.each do |expansion_name|
      expansion = Expansion.find_by_name(expansion_name)
      raise UnknownExpansionError.new("#{expansion_name} not stored.") unless expansion

      response(expansion_name).body.each do |card|
        rarity = Rarity.find_by_name(card["rarity"])
        raise UnknownRarityError.new("#{card["rarity"]} not stored.") unless rarity

        if card_valid? card
          Card.create(name: card["name"], expansion: expansion, rarity: rarity)
        end
      end
    end
  end

  private
    def response(expansion)
      response = Unirest.get "https://omgvamp-hearthstone-v1.p.mashape.com/cards/sets/#{expansion}",
        headers:{ "X-Mashape-Key" => SECRETS[:mashape_key] },
        parameters: { collectible: 1 }
    end

    def card_valid?(card)
      return false if card["cardId"].starts_with? "HERO" # there are actual hero cards

      true
    end
end