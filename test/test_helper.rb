require 'rubygems'
require 'test/unit'
require 'active_record'
require 'shoulda/rails'
require 'factory_girl'
require 'faker'

# Setting this makes parameterize work
$KCODE = 'UTF8'

# Makes TimeZone work
Time.zone = 'UTC'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'app'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

RAILS_DEFAULT_LOGGER = Logger.new(File.join(File.dirname(__FILE__), "debug.log"))
ActiveRecord::Base.logger = RAILS_DEFAULT_LOGGER

require "acts_as_commentable"
require "acts_as_content_node"
require "has_assets"
module PluginMock
  def acts_as_textiled(*args); end
  def acts_as_taggable_on(*args); end
end

ActiveRecord::Base.extend PluginMock
ActiveRecord::Base.send :include, Beef::Has::Assets
ActiveRecord::Base.send :include, Beef::Acts::ContentNode
ActiveRecord::Base.send :include, Beef::Acts::Publishable

require "models/article"
require "models/category"

ActiveRecord::Base.configurations = YAML::load(IO.read(File.dirname(__FILE__) + "/database.yml"))
ActiveRecord::Base.establish_connection(ENV["DB"] || "sqlite3mem")
ActiveRecord::Migration.verbose = false
load(File.join(File.dirname(__FILE__), "schema.rb"))

Factory.define :article do |article|
  article.title               {Faker::Lorem.words(5).join(' ')}
  article.description         {Faker::Lorem.sentence}
  article.body                {Faker::Lorem.paragraphs.join("\n\n\n")}
  article.association :category, :factory => :category
end

Factory.define :published_article, :parent => :article do |article|
  article.published_at   { Time.at(Time.now.to_i - rand(3.years)) }
end

Factory.define :category do |f|
  f.title  {Faker::Lorem.words(5).join(' ')}
end

