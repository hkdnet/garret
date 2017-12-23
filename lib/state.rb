class State
  def process(input, cur)
    raise NotImplementedError
  end

  def done?
    false
  end
end

# default final state
# Usage:
#   1xxRF
class StateF < State
  def done?
    true
  end
end

