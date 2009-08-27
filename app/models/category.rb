class Category < ActiveRecord::Base
  unloadable
  
  has_many :articles
  
  validates_presence_of :title
  validates_uniqueness_of :title
  
  named_scope :with, lambda { |many| {:joins => many.to_sym, :group => 'categories.id'} }
  
  before_save :set_url

private

  def set_url
    write_attribute :permalink, title.parameterize
  end  
end
