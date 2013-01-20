class ServiceResponse
  attr_reader :errors

  def initialize(error = nil)
    @errors = []
    @errors << error if error
  end
end
