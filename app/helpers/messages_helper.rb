module MessagesHelper
  
  def link_for_date(title, date)
    link_to(title, message_by_date_url(:channel_id => @channel.id, 
                                       :month => date.month,
                                       :year => date.year,
                                       :day => date.day))
  end
  
end
