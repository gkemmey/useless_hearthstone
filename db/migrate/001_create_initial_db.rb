class CreateInitialDb < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.integer         :expansion_id,      null: false
      t.integer         :rarity_id,         null: false

      t.string          :name,              null: false
    end

    add_index :cards, :name
    
    create_table :expansions do |t|
      t.string          :name,              null: false
    end

    create_table :rarities do |t|
      t.string          :name,              null: false
    end

    create_table :decks do |t|
      t.string          :name
      t.integer         :hearthpwn_id
      t.string          :style
      t.integer         :cost
      t.datetime        :uploaded_at

      t.boolean         :failed,            null: false, default: false
      t.text            :last_error
    end

    add_index :decks, :hearthpwn_id

    create_table :deck_listings do |t|
      t.integer         :card_id,           null: false
      t.integer         :deck_id,           null: false
      t.integer         :count,             null: false
    end
  end
end
