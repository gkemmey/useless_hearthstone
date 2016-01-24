require File.join(File.expand_path('../../..', __FILE__), 'config/loader.rb')

class SeedExpansionsAndRarities < ActiveRecord::Migration
  def up
    expansions = [
      "Basic", "Classic", "Naxxramas", "Goblins vs Gnomes", "Reward", "Blackrock Mountain",
      "The Grand Tournament", "The League of Explorers"
    ]

    expansions.each { |e| Expansion.create(name: e) }

    rarities = ["Free", "Common", "Legendary", "Epic", "Rare"]

    rarities.each { |r| Rarity.create(name: r) }
  end

  def down
    Expansion.destroy_all
    Rarity.destroy_all
  end
end