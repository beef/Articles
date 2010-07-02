class Article < ActiveRecord::Base
  belongs_to :category

  acts_as_content_node
  acts_as_commentable
  has_assets
  acts_as_textiled :body if respond_to?(:acts_as_textiled)
  acts_as_taggable_on :tags

  named_scope :categorised, lambda { |category|
    return {} if category.nil?
    category = Category.find(category) unless category.nil? or category.is_a? Category
    { :conditions => { :category_id => category.id }  }
  }

  named_scope :in_time_delta, lambda { |year, month, day|
    return {} if year.blank?
    from = Time.mktime(year, month || 1, day || 1)
    to   = from + 1.year
    to   = from + 1.month unless month.blank?
    to   = from + 1.day   unless day.blank?
    to   = to.tomorrow    unless month.blank?
    { :conditions => ['published_at BETWEEN ? AND ?', from, to ] }
  }

  default_scope :order => 'published_at DESC'

  validates_presence_of :body, :description, :tag_list, :if => :publish

  # Default per page options
  cattr_accessor :per_page
  @@per_page = 10

  # Finds one article which was posted on a certain date and matches the supplied dashed-title
  def self.find_by_permalink(year, month, day, permalink)
    if result = in_time_delta(year, month, day).first( :conditions => ["permalink = ?", permalink] )
      result
    else
      raise ActiveRecord::RecordNotFound, "Couldn't find article with permalink #{permalink} on #{year}.#{month}.#{day}}"
    end
  end

end
