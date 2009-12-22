ActionController::Routing::Routes.draw do |map|
  map.resources :categories, :has_many => :articles
  
  map.with_options :controller  => 'articles', :action => 'index' do |articles|
    articles.articles_day 'articles/:year/:month/:day',
      :year => /\d{4}/, :month => /\d{1,2}/, :day => /\d{1,2}/
    articles.articles_month 'articles/:year/:month',
      :year => /\d{4}/, :month => /\d{1,2}/
    articles.articles_day 'articles/:year',
      :year => /\d{4}/
    articles.articles_tagged 'articles/tagged/:tag.:format'
    articles.articles_authored 'articles/author/:permalink.:format'
  end
  map.article_permalink 'articles/:year/:month/:day/:permalink',
    :controller => 'articles', :action => 'show',
    :year => /\d{4}/, :day => /\d{1,2}/, :month => /\d{1,2}/,
    :path_prefix => nil
  map.resources :articles, :only => [:index], :collection => { :preview => :get }, :has_many => :comments

  map.namespace(:admin) do |admin|
    admin.resources :categories
    admin.resources :articles, :has_many => :comments, :member => { :preview => :put }, :collection => { :preview => :post }
    admin.resources :comments, :only => [:index, :destroy]
  end
end