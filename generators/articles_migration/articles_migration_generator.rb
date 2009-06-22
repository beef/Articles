class ArticlesMigrationGenerator < Rails::Generator::Base

  def manifest
    record do |m|
      m.migration_template "migration.rb",
                           'db/migrate',
                           :migration_file_name => "create_articles_categories_and_comments"
    end
  end
  
end