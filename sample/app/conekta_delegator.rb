class ConektaDelegator
  attr_reader :result

  def networkError(error)
    @result = error
    NSLog "ERROR: #{error.inspect}"
  end

  def tokenizationError(error)
    @result = error
    NSLog "TOKEN ERROR: #{error.inspect}"
  end

  def tokenizationSuccess(object)
    NSLog "TOKEN #{object.inspect}"
  end
end

