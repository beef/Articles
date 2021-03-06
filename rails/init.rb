require "acts-as-taggable-on"
require "acts_as_commentable"
require "articles"

config.to_prepare do
  ApplicationController.helper(ArticlesHelper)
  ApplicationController.helper(CommentsHelper)
  ApplicationController.helper(Beef::Articles::UrlHelper)
end
 
ActionController::Base.send :include, Beef::Articles::UrlHelper 