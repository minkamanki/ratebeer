class CreateMemberships < ActiveRecord::Migration[7.0]
  def change
    create_table :memberships do |t|
      t.integer :beer_club_id
      t.integer :user_id
      
      t.timestamps
    end

    add_index :memberships, [:user_id, :beer_club_id], unique: true
  end
end
