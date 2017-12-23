class State
  def process(input, cur)
    raise NotImplementedError
  end

  def done?
    false
  end
end
