require_relative './connect'


class CreateAll < ActiveRecord::Migration[7.0]
    def change 


        #telegram user 
        create_table :users, if_not_exists: true do |t|
            t.string :name
            t.integer :user_id, :limit => 8
            
            t.timestamps 
        end

        create_table :inline_keyboards, if_not_exists: true do |t|
            t.string :dump 
            t.string :message
            t.references :user, null: true, foreign_key: { to_table: :users }
            t.timestamps
        end

        #state of bot
        create_table :states, if_not_exists: true do |t|
            t.binary :state_dump 

            t.references :user, null: true, foreign_key: { to_table: :users }

            t.timestamps
        end
    

        create_table :activities, if_not_exists: true do |t|
            t.string :name 

            t.references :user, null: true, foreign_key: { to_table: :users }

            t.timestamps
        end

        create_table :stories, if_not_exists: true do |t|
            t.text :status 

            t.references :activity, null: false, foreign_key: { to_table: :activities }
            t.references :user, null: true, foreign_key: { to_table: :users }

            t.timestamps
        end
    
    
    end
end


CreateAll.new.change