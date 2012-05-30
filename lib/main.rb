#!/usr/bin/env ruby
# encoding: utf-8

# OO version of direct Connection Sample 

require "rubygems"
require "amqp"

class Consumer

  #
  # API
  #

  def handle_message(metadata, payload)
    puts "Received a message: #{payload}, content_type = #{metadata.content_type}"
  end # handle_message(metadata, payload)
end


class Worker

  #
  # API
  #


  def initialize(channel, queue_name = AMQ::Protocol::EMPTY_STRING, consumer = Consumer.new)
    @queue_name = queue_name
    @channel    = channel
    @channel.on_error(&method(:handle_channel_exception))

    @consumer   = consumer
  end # initialize

  def start
	puts "queue name: #{@queue_name}"
 
    @queue = @channel.queue(@queue_name, :exclusive => false, :durable => true)
    @queue.subscribe(&@consumer.method(:handle_message))
  end # start



  #
  # Implementation
  #

  def handle_channel_exception(channel, channel_close)
    puts "Oops... a channel-level exception: code = #{channel_close.reply_code}, message = #{channel_close.reply_text}"
  end # handle_channel_exception(channel, channel_close)
end


class Producer

  #
  # API
  #

  def initialize(channel, exchange)
    @channel  = channel
    @exchange = exchange
  end # initialize(channel, exchange)

  def publish(message, options = {})
    @exchange.publish(message, options)
  end # publish(message, options = {})


  #
  # Implementation
  #

  def handle_channel_exception(channel, channel_close)
    puts "Oops... a channel-level exception: code = #{channel_close.reply_code}, message = #{channel_close.reply_text}"
  end # handle_channel_exception(channel, channel_close)
end


t = Thread.new { EventMachine.run }
sleep(0.5)

connection = AMQP.connect(:host => '127.0.0.1', :user => 'guest', :password => 'guest')
channel  = AMQP::Channel.new(connection, :auto_recovery => true)
#TODO: error handling goes here 

queuename = "jQueue"

worker   = Worker.new(channel, queuename)
worker.start
producer = Producer.new(channel, channel.default_exchange)
puts "Publishing..."
producer.publish("Hello, Johnny", :routing_key => queuename)

puts "Ready ... yeah ..."

Signal.trap("INT"){connection.close{EventMachine.stop}}
t.join

