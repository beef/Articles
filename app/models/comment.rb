class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true

  acts_as_textiled :body => [:hard_breaks, :filter_html, :filter_styles] if respond_to?(:acts_as_textiled)

  validates_presence_of :name, :comment
  validates_acceptance_of :spam_filter, :accept => true, :on => :create, :allow_nil => false, :message => "believes message to be spam."
  validates_format_of :email, :with => %r{.+@.+\..+}

  attr_accessor :spam_filter

  def website=(url)
    write_attribute :website, url.gsub(/^http\:\/\//, '') unless url.blank?
  end

end