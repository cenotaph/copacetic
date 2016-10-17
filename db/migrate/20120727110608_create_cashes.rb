class CreateCashes < ActiveRecord::Migration
  def change
    create_table :cashes do |t|
      t.string :source
      t.string :title
      t.string :link_url
      t.text :content
      t.integer :order

      t.timestamps
    end
  end
end
