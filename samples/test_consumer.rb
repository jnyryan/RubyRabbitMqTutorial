# TOPIC Connection Sample

require "rubygems"
require "amqp"

EventMachine.run do
  AMQP.connect do |connection|
    channel  = AMQP::Channel.new(connection)
    exchange = channel.topic("sfdc/account", :auto_delete => false)

    # Subscribers.
    #channel.queue("", :exclusive => true) do |queue|
    #  queue.bind(exchange, :routing_key => "americas.north.#").subscribe do |headers, payload|
    #    puts "An update for North America: #{payload}, routing key is #{headers.routing_key}"
    #  end
    #end
    channel.queue("salesforce.sync", :durable => true).bind(exchange, :routing_key => "account.create").subscribe do |headers, payload|
      puts "salesforce Account Created for: #{payload}, routing key is #{headers.routing_key}"
    end  
    
    channel.queue("finance.sync", :durable => true).bind(exchange, :routing_key => "account.create").subscribe do |headers, payload|
      puts "finance Account Created for: #{payload}, routing key is #{headers.routing_key}"
    end    

    show_stopper = Proc.new {
      connection.close { EventMachine.stop }
    }

    EM.add_timer(2, show_stopper)
  end
end
