require 'json'

module Platform45
  class APIResponse
    def initialize(request, api_response, exception = nil)
      @success = (exception.nil? && (api_response && api_response.code == "200"))
      
      if api_response && api_response.code == "200"
        result = JSON.parse(api_response.body, symbolize_names: true)
        [:id,:x,:y, :status, :sunk, :game_status, :error, :prize].each do |field|
          instance_variable_set "@#{field}".to_sym, result[field]
        end
      end
    end

    # API Success
    def success?
      @success
    end


  end
end
