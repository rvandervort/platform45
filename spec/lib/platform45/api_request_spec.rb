require 'spec_helper.rb'

describe "Platform45::APIRequest" do
  let(:request) { Platform45::APIRequest.new }
  let(:name) { "Roger" }
  let(:email) { "testemail@xyz.com" }
  let(:uri_base) { "http://battle.platform45.com" }
  let(:api_response) { stub("NetHTTPResponseStub", code: "200", body: "{}") }

  before :each do
    Net::HTTP.any_instance.stub(:post)
  end


  describe ".make_request(uri, params)" do
    let(:uri) { URI.parse("http://localhost/fake_request") }

    it "POSTS the data to the specified URI" do
      Net::HTTP.any_instance.should_receive(:post).with(uri.path, "{}")
      response = request.make_request(uri, {})
    end

    context "on success" do
      it "returns an instance of Platform45::APIResponse with success" do
        Net::HTTP.any_instance.stub(:post).and_return(api_response)

        response = request.make_request(uri, {})

        response.should be_instance_of(Platform45::APIResponse)
        response.success?.should be_true
      end
    end

    context "on failure" do
      it "returns an instance of Platform45::APIResponse with failure" do
        Net::HTTP.any_instance.stub(:post).and_raise(Net::HTTPBadGateway)
        response = request.make_request(uri, {})
        response.should be_instance_of(Platform45::APIResponse)
        response.success?.should be_false
      end
    end
  end

  describe ".nuke(game_id, x, y)" do
    let(:game_id) { "1234" }
    let(:x) { 1 }
    let(:y) { 1 }

    before :each do
      request.stub(:make_request).and_return(Platform45::APIResponse.new(request, nil))
    end

    it "uses the /nuke url endpoint" do
      request.should_receive(:full_uri).with("nuke")
      request.nuke game_id, x, y
    end

    it "makes the request" do
      request.should_receive(:make_request).with(request.full_uri("nuke"), {"id" => game_id, "x" => x, "y" => y})
      request.nuke game_id, x, y
    end

    it "returns a Platform45::APIResponse object" do
      request.nuke(game_id, x, y).should be_instance_of(Platform45::APIResponse)
    end
  end

  describe ".register(name, email)" do
    before :each do
      request.stub(:make_request).and_return(Platform45::APIResponse.new(request, nil))
    end

    it "uses the /register url endpoint" do
      request.should_receive(:full_uri).with("register")
      request.register name, email
    end

    it "makes the request" do
      request.should_receive(:make_request).with(request.full_uri("register"), {"name" => name, "email" => email})
      request.register name, email
    end

    it "returns a Platform45::APIResponse object" do
      request.register(name, email).should be_instance_of(Platform45::APIResponse)
    end
  end

end
