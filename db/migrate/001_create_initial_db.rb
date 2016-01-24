class CreateInitialDb < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.integer         :expansion_id,     null: false
      t.integer         :rarity_id,         null: false

      t.string          :name,              null: false
    end
    
    create_table :expansions do |t|
      t.string          :name,              null: false
    end

    create_table :rarities do |t|
      t.string          :name,              null: false
    end
  end
end
