class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.text :post_content
      t.integer :user_id
    end
  end
end
