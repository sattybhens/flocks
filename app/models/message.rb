class Message < ActiveRecord::Base
  
  belongs_to :channel

  named_scope :created, lambda{ |day| { :conditions => ['DATE(created_at)=DATE(?)', day] }}
  named_scope :descending, :order => 'created_at DESC'
  
end
