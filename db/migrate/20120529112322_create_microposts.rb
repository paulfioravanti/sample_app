class CreateMicroposts < ActiveRecord::Migration
  def up
    create_table :microposts do |t|
      t.belongs_to :user, null: false

      t.timestamps
    end
    add_index :microposts, [:user_id, :created_at]
    Micropost.create_translation_table! content: :string
  end

  def down
    remove_index :microposts, [:user_id, :created_at]
    drop_table :microposts
    Micropost.drop_translation_table!
  end
end
