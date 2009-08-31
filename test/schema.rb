ActiveRecord::Schema.define(:version => 0) do
  create_table "articles", :force => true do |t|
    t.string   "title"
    t.string   "permalink"
    t.datetime "published_at"
    t.datetime "published_to"
    t.text     "body"
    t.string   "description"
    t.boolean  "allow_comments",  :default => false
    t.string   "cached_tag_list"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end
  
  create_table "categories", :force => true do |t|
    t.string   "title"
    t.string   "description"
    t.string   "permalink"
    t.datetime "created_at"
    t.datetime "updated_at"
  end
end