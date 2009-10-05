class Extension < ActiveRecord::Base
  has_permalink :name  
  belongs_to :author, :class_name => 'User', :foreign_key => :user_id, :counter_cache => true
  has_and_belongs_to_many :versions
  
  acts_as_taggable
  
  before_validation :set_author_name

  validates_presence_of :name, :summary, :scm_location
  #  validates_uniqueness_of :name, :scm_location
  validates_url_of :website, :message => 'is not valid or not responding', :enable_http_check => true
  validates_presence_of :author_name, :message => "must be provided if you don't provide existing user."
  
  named_scope :recent, lambda { |*args| {:limit => (args.first || 3), :order => 'created_at DESC'} }  

  def owned_by(user)
    self.author == user
  end
  
  def github?
    scm_location =~ /github.com/    
  end

  def set_author_name
    if author && author_name.blank?
      self.author_name = author.name
    end
  end
end
