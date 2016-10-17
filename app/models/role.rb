class Role < ActiveRecord::Base
  has_and_belongs_to_many :admin_users, :join_table => 'roles_admin_users'
end