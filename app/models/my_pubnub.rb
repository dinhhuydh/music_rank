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
end