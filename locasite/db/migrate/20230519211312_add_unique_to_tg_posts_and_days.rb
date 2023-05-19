class AddUniqueToTgPostsAndDays < ActiveRecord::Migration[7.0]
  def up
    change_table :tg_posts do |t|
      t.index :tg_post_id, unique: true
    end

    change_table :days do |t|
      t.index :date, unique: true
    end
  end

  def down
    remove_index :tg_posts, :tg_post_id
    remove_index :days, :date
  end
end
