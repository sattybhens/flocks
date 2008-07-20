ActionController::Routing::Routes.draw do |map|
  map.message_by_date 'channels/:channel_id/messages/:year/:month/:day', :controller => 'messages'
  map.resources :channels, :has_many => :messages
  map.resources :messages
  map.root :controller => 'channels', :action => 'index'
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
