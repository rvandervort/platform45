require 'net/http'
require 'uri'

module Platform45
  class << self
    def base_uri
      "http://battle.platform45.com"
    end
  end

  class APIRequest
    def full_uri(suffix)
      URI.parse("#{Platform45.base_uri}/#{suffix}")
    end
    
    def make_request(uri, params)
      http = Net::HTTP.new(uri.host, 80)

      begin
        response = http.post(uri.path, params) 
        Platform45::APIResponse.new self, response
      rescue Exception => e
        Platform45::APIResponse.new self, nil, e
      end
    end

    def nuke(game_id, x, y)
      uri = full_uri("nuke")

      make_request(uri, {"id" => game_id, "x" => x, "y" => y})
    end

    def register(name, email)
      uri = full_uri("register")

      make_request(uri, {"name" => name, "email" => email})
    end
  end
end


