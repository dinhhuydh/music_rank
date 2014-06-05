class RoomsController < ApplicationController
  def create
    channel = MyPubnub.instance.generate_chat_channel(params[:sender_id], params[:receiver_id], params[:message])
    render :json => { :channel => channel }
  end
end
