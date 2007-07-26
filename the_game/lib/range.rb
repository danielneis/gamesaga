class Range

  def intersects?(range)
    ((self.begin >= range.begin && self.begin <= range.end) or
    (self.end >= range.begin && self.end <= range.end))
  end
end
