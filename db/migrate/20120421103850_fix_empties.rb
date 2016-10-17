class FixEmpties < ActiveRecord::Migration
  def up
    execute("UPDATE publishers set name=' no publisher listed' WHERE name = ''")
    execute("UPDATE labels SET name = ' no label listed' WHERE name = ''")
    execute("UPDATE serials SET name = ' no serial' WHERE name   = ''")
    execute("UPDATE books SET publisher_id = 86 WHERE publisher_id is null")
    execute("UPDATE comics SET publisher_id = 86 WHERE publisher_id is null")
    rename_column :posts, :user_id, :admin_user_id
    execute("UPDATE posts SET title = id WHERE title = ''")
    execute("DELETE from books WHERE title = ''")
    Article.find_each(&:save)
    Comic.find_each(&:save)
    Book.find_each(&:save)
    Dvd.find_each(&:save)
    Cd.find_each(&:save)
    Serial.find_each(&:save)
    Special.find_each(&:save)
    Post.find_each(&:save)
    Publisher.find_each(&:save)
    Label.find_each(&:save)
    Creator.find_each(&:save)
    Director.find_each(&:save)
    Justin.find_each(&:save)
  end

  def down
  end
end
