require 'spec_helper'
require "ostruct"
require "active_support"

# RSpec example
describe Consumer do
  describe "when a new message arrives" do
    subject { described_class.new }

    let(:metadata) do
      o = OpenStruct.new

      o.content_type = "application/json"
      o
    end
    j = ActiveSupport::JSON
    #let(:payload)  { JSON.encode({ :command => "reload_config" }) }
    let(:payload)  { j.encode({ :command => "reload_config" }) }
#j.encode("A string")

    it "does some useful work" do
      # check preconditions here if necessary

      subject.handle_message(metadata, payload)

      # add your code expectations here
    end
  end
end
