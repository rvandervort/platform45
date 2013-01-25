require 'json'

module Platform45
  class APIResponse
    
    def coordinates
      if @response_vars
        [@response_vars[:x], @response_vars[:y]]
      end
    end
    
    def game_id
      @response_vars[:id]
    end

    def error
      @response_vars[:error]
    end

    def hit?
      @response_vars[:status] == "hit"
    end


    def initialize(request, api_response, exception = nil)
      @success = (exception.nil? && (api_response && api_response.code == "200"))
      @response_vars = {}

      if api_response && api_response.body
        @response_vars = JSON.parse(api_response.body, symbolize_names: true)
      end

      if exception
        @response_vars ||= {}
        @response_vars[:error] = exception.to_s
      end

      if @response_vars[:error]
        @success = false
      end


    end

    def miss?
      @response_vars[:status] == "miss"
    end

    def prize
      @response_vars[:prize]
    end

    def success?
      @success
    end
    
    def status
      @response_vars[:status]
    end

    def sunk?
      !sunk.nil?
    end

    def sunk
      @response_vars[:sunk]
    end

    def won?
      @response_vars[:game_status] == "lost" 
    end

  end
end
