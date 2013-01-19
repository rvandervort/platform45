require 'spec_helper.rb'


describe Platform45::APIResponse do
  let(:request) { Platform45::APIRequest.new }
  let(:api_response) { stub "APIResponse", code: "200", body: "" }
  let(:exception) { stub("HTTPException") }

  describe ".initialize(request, api_response, exception = nil)" do
    context "on API failure" do
      it "sets success = false if the response is not 200" do
        api_response.stub(:code).and_return("400")
        response = Platform45::APIResponse.new(request, api_response, nil)  
        response.success?.should be_false
      end

      it "sets success = false if the exception isn't nil" do
        response = Platform45::APIResponse.new(request, nil, exception)
        response.success?.should be_false
      end
    end
    context "on API Success" do
      before :each do
        api_response.stub(:body).and_return "{\"id\": \"23\"}"
      end

      it "sets success = true if the status is 200" do
        response = Platform45::APIResponse.new(request, api_response, nil)
        response.success?.should be_true
      end

      it "sets the @response_vars hash" do
        response = Platform45::APIResponse.new(request, api_response, nil)
        response.instance_variable_get(:@response_vars).should_not == nil
      end
    end
  end
end
