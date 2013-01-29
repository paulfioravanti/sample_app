class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.belongs_to :follower, null: false
      t.belongs_to :followed, null: false

      t.timestamps
    end

    add_index :relationships, :follower
    add_index :relationships, :followed
    add_index :relationships, [:follower, :followed], unique: true
  end
end
