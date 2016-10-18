# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20161018113536) do

  create_table "active_admin_comments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "resource_id",                 null: false
    t.string   "resource_type",               null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body",          limit: 65535
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "namespace"
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
    t.index ["resource_type", "resource_id"], name: "index_admin_notes_on_resource_type_and_resource_id", using: :btree
  end

  create_table "admin_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "email",                                default: "", null: false
    t.string   "encrypted_password",     limit: 128,   default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.string   "username"
    t.string   "real_name"
    t.text     "about_me",               limit: 65535
    t.string   "location"
    t.string   "website"
    t.index ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "admins", id: false, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1" do |t|
    t.string "param", limit: 24
    t.text   "value", limit: 65535
  end

  create_table "articles", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1" do |t|
    t.string  "title"
    t.text    "content",     limit: 16777215
    t.text    "blurb",       limit: 65535
    t.string  "slug",                                         null: false
    t.boolean "published"
    t.float   "sortorder",   limit: 24
    t.boolean "in_universe",                  default: false, null: false
    t.boolean "quotidian",                    default: false, null: false
    t.index ["slug"], name: "index_articles_on_slug", using: :btree
  end

  create_table "authentications", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "admin_user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "books", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1" do |t|
    t.string   "title"
    t.integer  "publisher_id"
    t.boolean  "hardcover"
    t.integer  "pagecount"
    t.float    "listprice",      limit: 53
    t.float    "price",          limit: 53
    t.boolean  "fiction"
    t.datetime "dateadded",                    default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.boolean  "instock",                      default: true
    t.text     "description",    limit: 65535
    t.string   "isbn"
    t.string   "ean"
    t.integer  "numbersold"
    t.string   "image",          limit: 128
    t.text     "shortdesc",      limit: 65535
    t.integer  "justin_id"
    t.string   "tinydesc",       limit: 250
    t.datetime "created_at",                                                        null: false
    t.datetime "updated_at",                                                        null: false
    t.float    "weight",         limit: 24,    default: 1.0,                        null: false
    t.string   "slug",                                                              null: false
    t.integer  "creators_count",               default: 0
    t.index ["slug"], name: "index_books_on_slug", using: :btree
  end

  create_table "cashes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "source"
    t.string   "title"
    t.string   "link_url"
    t.text     "content",    limit: 65535
    t.integer  "order"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "cds", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1" do |t|
    t.string   "title"
    t.string   "artist"
    t.integer  "label_id"
    t.integer  "numofdiscs"
    t.integer  "genre_id"
    t.float    "listprice",   limit: 53
    t.float    "price",       limit: 53
    t.datetime "dateadded",                 default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.boolean  "instock",                   default: true
    t.text     "description", limit: 65535
    t.integer  "numbersold"
    t.integer  "justin_id"
    t.text     "shortdesc",   limit: 65535
    t.string   "tinydesc"
    t.string   "image",       limit: 128
    t.string   "catno",       limit: 15
    t.string   "keywords",    limit: 320
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "weight",      limit: 24,    default: 0.5,                        null: false
    t.string   "slug",                                                           null: false
    t.index ["slug"], name: "index_cds_on_slug", using: :btree
  end

  create_table "ckeditor_assets", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
    t.index ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree
  end

  create_table "comics", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1" do |t|
    t.string   "title"
    t.string   "issue"
    t.integer  "publisher_id"
    t.float    "listprice",      limit: 53
    t.float    "price",          limit: 53
    t.datetime "dateadded",                    default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.boolean  "instock",                      default: true
    t.text     "description",    limit: 65535
    t.integer  "pagecount"
    t.integer  "dimensions"
    t.integer  "numbersold"
    t.string   "image",          limit: 128
    t.text     "shortdesc",      limit: 65535
    t.string   "tinydesc",       limit: 250
    t.integer  "justin_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "weight",         limit: 24,    default: 1.0,                        null: false
    t.string   "slug",                                                              null: false
    t.integer  "creators_count",               default: 0
    t.index ["slug"], name: "index_comics_on_slug", using: :btree
  end

  create_table "comments", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1" do |t|
    t.integer  "user_id"
    t.text     "post",      limit: 65535
    t.integer  "parent_id"
    t.datetime "date",                    default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.boolean  "approved",                default: false
  end

  create_table "comments_books", id: false, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1" do |t|
    t.integer "comment_id"
    t.integer "book_id"
  end

  create_table "comments_cds", id: false, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1" do |t|
    t.integer "comment_id"
    t.integer "cd_id"
  end

  create_table "comments_comics", id: false, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1" do |t|
    t.integer "comment_id"
    t.integer "comic_id"
  end

  create_table "comments_dvds", id: false, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1" do |t|
    t.integer "comment_id"
    t.integer "dvd_id"
  end

  create_table "creators", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1" do |t|
    t.string "firstname"
    t.string "lastname"
    t.text   "description", limit: 65535
    t.string "slug",                      null: false
    t.index ["slug"], name: "index_creators_on_slug", using: :btree
  end

  create_table "creators_books", id: false, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1" do |t|
    t.integer "creator_id"
    t.integer "book_id"
  end

  create_table "creators_comics", id: false, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1" do |t|
    t.integer "creator_id"
    t.integer "comic_id"
  end

  create_table "directors", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1" do |t|
    t.string "firstname"
    t.string "lastname"
    t.text   "description", limit: 65535
    t.string "slug",                      null: false
    t.index ["slug"], name: "index_directors_on_slug", using: :btree
  end

  create_table "directors_dvds", id: false, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1" do |t|
    t.integer "director_id"
    t.integer "dvd_id"
  end

  create_table "dvds", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1" do |t|
    t.string   "title"
    t.integer  "director_id"
    t.integer  "year"
    t.string   "country"
    t.integer  "publisher_id"
    t.float    "listprice",    limit: 53
    t.float    "price",        limit: 53
    t.datetime "dateadded",                  default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.boolean  "instock",                    default: true
    t.text     "description",  limit: 65535
    t.integer  "numbersold"
    t.text     "shortdesc",    limit: 65535
    t.integer  "justin_id"
    t.string   "image",        limit: 128
    t.string   "tinydesc",     limit: 250
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "weight",       limit: 24,    default: 0.5,                        null: false
    t.string   "slug",                                                            null: false
    t.index ["slug"], name: "index_dvds_on_slug", using: :btree
  end

  create_table "frontitems", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1" do |t|
    t.string   "item_type",              null: false
    t.string   "image",      limit: 128
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "item_id",                null: false
    t.integer  "position",               null: false
  end

  create_table "images", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1" do |t|
    t.string "filename"
  end

  create_table "images_comics", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1" do |t|
    t.integer "image_id"
    t.integer "comic_id"
  end

  create_table "items_creators", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer "item_id"
    t.string  "item_type"
    t.integer "creator_id"
  end

  create_table "items_specials", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer "item_id"
    t.string  "item_type"
    t.integer "special_id"
  end

  create_table "justins", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1" do |t|
    t.date    "day"
    t.string  "name",        limit: 64
    t.text    "description", limit: 65535
    t.string  "slug",                      null: false
    t.boolean "published"
    t.index ["slug"], name: "index_justins_on_slug", using: :btree
  end

  create_table "labels", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1" do |t|
    t.string "name"
    t.text   "description", limit: 65535
    t.string "keywords",    limit: 320
    t.string "tinydesc",    limit: 250
    t.string "slug",                      null: false
    t.index ["slug"], name: "index_labels_on_slug", using: :btree
  end

  create_table "logos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "filename"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "posts", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1" do |t|
    t.string   "title",         limit: 200
    t.text     "body",          limit: 65535
    t.datetime "created_at"
    t.integer  "admin_user_id"
    t.datetime "modified_at"
    t.string   "slug",                        null: false
    t.boolean  "published"
    t.index ["slug"], name: "index_posts_on_slug", using: :btree
  end

  create_table "publishers", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1" do |t|
    t.string "name"
    t.text   "description", limit: 65535
    t.string "tinydesc",    limit: 250
    t.string "keywords",    limit: 320
    t.string "slug",                      null: false
    t.index ["slug"], name: "index_publishers_on_slug", using: :btree
  end

  create_table "roles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles_admin_users", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer "role_id"
    t.integer "admin_user_id"
  end

  create_table "searches", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "term"
    t.integer  "count"
    t.integer  "hits"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "serials", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1" do |t|
    t.string "name"
    t.text   "description", limit: 65535
    t.string "slug",                      null: false
    t.index ["slug"], name: "index_serials_on_slug", using: :btree
  end

  create_table "serials_comics", id: false, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1" do |t|
    t.integer "serial_id"
    t.integer "comic_id"
  end

  create_table "specials", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1" do |t|
    t.string   "name"
    t.text     "description", limit: 65535
    t.string   "keywords",    limit: 320
    t.string   "tinydesc",    limit: 250
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug",                      null: false
    t.index ["slug"], name: "index_specials_on_slug", using: :btree
  end

  create_table "specials_books", id: false, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1" do |t|
    t.integer "special_id"
    t.integer "book_id"
  end

  create_table "specials_cds", id: false, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1" do |t|
    t.integer "special_id"
    t.integer "cd_id"
  end

  create_table "specials_comics", id: false, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1" do |t|
    t.integer "special_id"
    t.integer "comic_id"
  end

  create_table "specials_dvds", id: false, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1" do |t|
    t.integer "special_id"
    t.integer "dvd_id"
  end

  create_table "users", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1" do |t|
    t.string   "login"
    t.string   "crypted_password"
    t.string   "email"
    t.string   "salt"
    t.datetime "created_at",                           default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.string   "real_name"
    t.string   "role",                      limit: 10, default: "user"
    t.datetime "updated_at"
    t.string   "remember_token",            limit: 40
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           limit: 40
    t.datetime "activated_at"
    t.index ["login"], name: "index_users_on_login", unique: true, using: :btree
  end

end
