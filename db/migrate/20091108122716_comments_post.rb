class CommentsPost < ActiveRecord::Migration
  def self.up
      create_table :comments_posts do |t|
        t.references :comment
        t.references :post
      end
  end

  def self.down
    drop_table :comments_posts
  end
end
