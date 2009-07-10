require "acts-as-taggable-on"
require "acts_as_commentable"
require "articles"

config.to_prepare do
  ApplicationController.helper(ArticlesHelper)
  ApplicationController.helper(Beef::Articles)
end
 
ActionController::Base.send :include, Beef::Articles 