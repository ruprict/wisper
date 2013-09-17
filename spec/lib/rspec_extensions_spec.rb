require 'spec_helper'
require 'wisper/rspec/stub_wisper_publisher'

describe Wisper do
  describe "given a piece of code invoking a publisher" do
    class CodeThatReactsToEvents
      def do_something
        publisher = MyPublisher.new
        publisher.on(:some_event) do |variable1, variable2|
          return "Hello with #{variable1} #{variable2}!"
        end
        publisher.execute
      end

      def do_something_args(arg1)
        publisher = ArgsPublisher.new
        
        publisher.on(:some_event) do |variable1|
          return "Hello with #{variable1}!"
        end
        publisher.execute("bar")
      end
    end

    class ArgsPublisher
      include Wisper::Publisher

      def execute(an_arg) 
        broadcast(:some_event, an_arg)
      end
    end

    context "when stubbing the publisher to emit an event" do
      before do
        stub_wisper_publisher("MyPublisher", :execute, :some_event, "foo1", "foo2")
      end

      it "emits the event" do
        response = CodeThatReactsToEvents.new.do_something
        response.should == "Hello with foo1 foo2!"
      end
    end

    context "when stubbing a publisher that takes arguments" do
      before do
        stub_wisper_publisher_with_args("ArgsPublisher", :execute, :some_event, "foo1", "foo2")
      end

      it "emits the event" do
        response = CodeThatReactsToEvents.new.do_something_args("bar")

        response.should == "Hello with foo1!"
      end
    
     
    
    end
  end
end
