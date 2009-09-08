class Category < ActiveRecord::Base
  has_many :articles
  
  validates_presence_of :title
  validates_uniqueness_of :title
  
  named_scope :with, lambda { |many| {:joins => many.to_sym, :group => 'categories.id'} }
  
  before_save :set_url
  before_destroy :no_content?

  def has_content?
    has_content = false
    self.class.reflect_on_all_associations.each do |assoc|
      if send(assoc.name).any?
        has_content = true
        break
      end
    end
    return has_content
  end
  
  def no_content?
    !has_content?
  end

private

  def set_url
    write_attribute :permalink, title.parameterize
  end  
end
