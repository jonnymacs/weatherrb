require File.expand_path '../test_helper.rb', __FILE__

include Rack::Test::Methods

def app
  Weather
end

describe Service::Base, "Generic services" do

  class MockService < ::Service::Base
    base_uri "http://foo.bar"
    format :json
  end

  it "should provide HTTParty class methods" do
    [:get, :put, :post, :patch, :delete].each do |http_method|
      MockService.methods.must_include http_method
    end
  end

  it "should return a tuple of response code, response body when handling a response" do
    response = OpenStruct.new(code: 200, parsed_response: "foo man foo")
    status, response  = MockService.handle_response(:a_method, its_params = { q: 123}, response)
    status.must_equal 200
    response.must_equal "foo man foo"
  end

  it "should raise a NetWorkError on handle response if response code is not 200, 404" do
    response = OpenStruct.new(code: 400, parsed_response: "400 not good")
    I18n.stub(:t, "a nice error message") do
      exception = assert_raises(Service::Error::NetworkError) do
        MockService.handle_response(:a_method, its_params = { q: 123}, response)
      end
      exception.message.must_equal "a nice error message"
    end
  end

end
