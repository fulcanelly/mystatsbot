class CreateTgPosts < ActiveRecord::Migration[7.0]
  def change
    create_table :tg_posts do |t|
      t.string :tg_post_id
      t.references :day, null: false, foreign_key: true

      t.timestamps
    end
  end
end
