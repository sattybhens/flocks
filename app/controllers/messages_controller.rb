class MessagesController < ApplicationController
  
  def index
    @channel = Channel.find(params[:channel_id])
    @date = Date.today
    @date = Date.parse([params[:year], params[:month], params[:day]].join('/')) if params[:year] && params[:month] && params[:day]
    @messages = @channel.messages.created(@date).descending
  end
  
  def destroy
    @message = Message.find(params[:id])
    @message.destroy
    redirect_to :back
  end
  
end
