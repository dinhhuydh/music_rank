class MyPubnub 
  include Singleton
  require 'pubnub'

  def initialize
    @pubnub = Pubnub.new(
    :subscribe_key    => APP_CONFIG['pubnub_subcribe_key'],
    :publish_key      => APP_CONFIG['pubnub_publish_key'],
    :error_callback   => lambda { |msg|
      puts "Error callback says: #{msg.inspect}"
    },
    :connect_callback => lambda { |msg|
      puts "CONNECTED: #{msg.inspect}"
    }
    )
  end

  def publish(message, channel, http_sync=true)
    @pubnub.publish(:message => message, :channel => channel, :http_sync => http_sync)
  end

  def generate_chat_channel(sender_id, receiver_id, message)
    channel = SecureRandom.hex 
    message_hash = {
      :username => User.find_by_id(sender_id).name,
      :content => message
    }
    @pubnub.publish(message_hash, channel)
    channel
  end
end