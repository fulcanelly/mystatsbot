require_relative './connect'


class CreateAll < CoreCreateAll
    def change 

        create_table :user_props, if_not_exists: true do |t|
            t.string :key_text
            t.string :data_dump

            t.belongs_to :user
        end
        
        create_table :inline_keyboards, if_not_exists: true do |t|
            t.string :dump 
            t.string :message
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
    
        super
    end
end


