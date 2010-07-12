module StringExtensions
  def continuous
    if self == "week" || self == "month" || self == "hour" || self == "year"
      self + 'ly'
    elsif self == "day"
      return "daily"
    end
  end

  def uncontinuous
    if self == "daily"
      return "day"
    else
      self.gsub('ly','')
    end
  end
end


class String
  include StringExtensions
end

