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
    @queue = @channel.queue(@queue_name, :exclusive => true, :durable => true)
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


AMQP.start("amqp://guest:guest@127.0.0.1") do |connection, open_ok|
  channel  = AMQP::Channel.new(connection)
  #worker   = Worker.new(channel, "amqpgem.objects.integration")
  worker   = Worker.new(channel, "Breaking.the.Bank")
  worker.start

  producer = Producer.new(channel, channel.default_exchange)
  puts "Publishing..."
  #producer.publish("Hello, world", :routing_key => "amqpgem.objects.integration")
  producer.publish("Hello, Johnny", :routing_key => "Breaking.the.Bank")

  # stop in 2 seconds
  EventMachine.add_timer(2.0) { connection.close { EventMachine.stop } }
end
