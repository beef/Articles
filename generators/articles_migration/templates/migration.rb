class CreateArticlesCategoriesAndComments < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.string :title
      t.string :permalink
      t.datetime :published_at
      t.datetime :published_to
      t.text :body
      t.string :description
      t.boolean :allow_comments, :default => false
      t.string :cached_tag_list
      t.references :created_by, :updated_by, :category

      t.timestamps
    end

    create_table :categories do |t|
      t.string :title
      t.string :description, :permalink

      t.timestamps
    end
    
    add_index :categories, :permalink

    create_table :comments do |t|
      t.text :comment, :default => ""
      t.references :commentable, :polymorphic => true

      t.string :website, :default => ""
      t.string :name, :default => ""
      t.string :email, :default => ""
      t.string :spam_signature
      t.timestamps
    end

    add_index :comments, :commentable_type
    add_index :comments, :commentable_id
  end

  def self.down
    drop_table :categories
    drop_table :comments
    drop_table :articles
  end
end