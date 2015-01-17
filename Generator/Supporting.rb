# For rounding time effectively
class WDay
end

class Time
  def round(sec=1)
    down = self - (self.to_i % sec)
    up = down + sec

    difference_down = self - down
    difference_up = up - self

    if (difference_down < difference_up)
      return down
    else
      return up
    end
  end
end

# Takes date from the first and time from the second
def NormalizeTimeToDate first, second
	result = Time.new(first.year, first.month, first.day, second.hour, second.min, second.sec, second.gmt_offset)
end

