# FANOUT Connection Sample

require "rubygems"
require "amqp"

AMQP.start("amqp://127.0.0.1:5672") do |connection|
  channel  = AMQP::Channel.new(connection)
  exchange = channel.fanout("nba.scores")

  channel.queue("joe", :auto_delete => false).bind(exchange).subscribe do |payload|
    puts "#{payload} => joe"
  end

  channel.queue("aaron", :auto_delete => false).bind(exchange).subscribe do |payload|
    puts "#{payload} => aaron"
  end

  channel.queue("bob", :auto_delete => false).bind(exchange).subscribe do |payload|
    puts "#{payload} => bob"
  end

  exchange.publish("BOS 101, NYK 89").publish("ORL 85, ALT 88")

  # disconnect & exit after 2 seconds
  EventMachine.add_timer(2) do
    exchange.delete

    connection.close { EventMachine.stop }
  end
end
