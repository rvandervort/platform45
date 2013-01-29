class RangeCalculator
  def horizontal(start_x, start_y, length)
    return (start_x..(start_x + length - 1)), start_y
  end

  def vertical(start_x, start_y, length)
    return start_x, (start_y..(start_y + length - 1))
  end 

end
