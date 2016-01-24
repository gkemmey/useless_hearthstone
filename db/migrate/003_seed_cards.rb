require File.join(File.expand_path('../../..', __FILE__), 'config/loader.rb')

class SeedCards < ActiveRecord::Migration
  def up
    ExpansionLoader.new(Expansion.pluck(:name)).load_cards
  end

  def down
    Card.destroy_all
  end
end