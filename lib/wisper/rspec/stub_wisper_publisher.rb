### Wisper Stubbing
# This is a proposal for integration as part of wisper core
# for testing: https://github.com/krisleech/wisper/issues/1
class TestWisperPublisher
  include Wisper::Publisher
  def initialize(*args); end
end

def stub_wisper_publisher(clazz, called_method, event_to_publish, *published_event_args)
  stub_const(clazz, Class.new(TestWisperPublisher) do
    define_method(called_method) do |*args|
      publish(event_to_publish, *published_event_args)
    end
  end)
end

def stub_wisper_publisher_with_args(clazz, called_method, event_to_publish, *published_event_args)
  stub_const(clazz, Class.new(TestWisperPublisher) do
    define_method(called_method) do |*args|
      publish(event_to_publish, *published_event_args)
    end
  end)
end
