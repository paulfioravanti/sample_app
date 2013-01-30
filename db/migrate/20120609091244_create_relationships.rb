class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.belongs_to :follower, null: false
      t.belongs_to :followed, null: false

      t.timestamps
    end

    add_index :relationships, :follower_id
    add_index :relationships, :followed_id
    add_index :relationships,
              [:follower_id, :followed_id],
              unique: true
  end
end
