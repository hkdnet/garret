class ExpandableString
  def initialize(str)
    @positive_str = str
    @negative_str = ' '
  end

  def [](cur)
    if cur.negative?
      @negative_str[-cur]
    else
      @positive_str[cur]
    end
  end

  def []=(cur, val)
    if cur.negative?
      @negative_str[-cur] = val
    else
      @positive_str[cur] = val
    end
  end

  def to_s
    @positive_str.to_s
  end
end

