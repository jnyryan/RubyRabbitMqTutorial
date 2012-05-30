# TOPIC Connection Sample

require "rubygems"
require "amqp"

EventMachine.run do
  AMQP.connect do |connection|
    channel  = AMQP::Channel.new(connection)
    exchange = channel.topic("sfdc/account", :auto_delete => false)

    EM.add_timer(1) do
      exchange.publish("new account for john", :routing_key => "account.create").
		publish("updated account for john", :routing_key => "account.update")
        puts "Publishing..."
    end


    show_stopper = Proc.new {
      connection.close { EventMachine.stop }
    }

    EM.add_timer(2, show_stopper)
  end
end
