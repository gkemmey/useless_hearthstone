require File.join(File.expand_path('../..', __FILE__), 'config/loader.rb')

cards = {}

Card.joins(:rarity).select("cards.id, cards.name, rarities.name AS rarity").each do |c|
  cards[c.id] = { name: c.name, rarity: c.attributes["rarity"], count: 0 }
end

Deck.all.each do |deck|
  deck.deck_listings.each do |listing|
    cards[listing.card_id][:count] += listing.count
  end
end

puts "Analyzing #{Deck.count} decks:\n"

rarities = { "Legendary" => [], "Epic" => [], "Rare" => [], "Common" => [] }

cards.each do |_, card|
  next unless rarities.keys.include? card[:rarity]

  rarities[card[:rarity]] << [card[:count], card[:name]]
end

longest_name = Card.pluck(:name).map(&:length).max

puts "\nUseless Legendaries:\n"
rarities["Legendary"].sort.each do |count, name|
  printf("%-#{longest_name}s #{count}\n", name)
end

puts "\nUseless Epics:\n"
rarities["Epic"].sort.each do |count, name|
  printf("%-#{longest_name}s #{count}\n", name)
end

puts "\nUseless Rares:\n"
rarities["Rare"].sort.each do |count, name|
  printf("%-#{longest_name}s #{count}\n", name)
end

puts "\nUseless Commons:\n"
rarities["Common"].sort.each do |count, name|
  printf("%-#{longest_name}s #{count}\n", name)
end