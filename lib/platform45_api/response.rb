require 'json'

module Platform45
  class APIResponse
    
    def coordinates
      if @response_vars
        [@response_vars[:x], @response_vars[:y]]
      end
    end
    
    def game_id
      @response_vars && @response_vars[:id]
    end

    def hit?
      @response_vars && @response_vars[:status] == "hit"
    end


    def initialize(request, api_response, exception = nil)
      @success = (exception.nil? && (api_response && api_response.code == "200"))
      
      if api_response && api_response.code == "200"
        @response_vars = JSON.parse(api_response.body, symbolize_names: true)
      else
        @response_vars = nil
      end
    end

    def miss?
      @response_vars && @response_vars[:status] == "miss"
    end

    def prize
      @response_vars && @response_vars[:prize]
    end

    def success?
      @success
    end
    
    def sunk?
      !sunk.nil?
    end

    def sunk
      @response_vars && @response_vars[:sunk]
    end

    def won?
      @response_vars && @response_vars[:game_status] == "lost" 
    end

  end
end
