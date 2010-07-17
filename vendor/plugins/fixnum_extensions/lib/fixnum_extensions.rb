module FixnumExtensions
  def numberst
    num_str = self.to_s
    numbers = num_str.split(/([\d])/)
    last_number = numbers.last.to_i
    puts last_number

    if last_number == 1
      tmp = "st"
    elsif last_number == 2
      tmp = "nd"
    elsif last_number == 3
      tmp = "rd"
  elsif last_number >= 4 || last_number == 0
      tmp = "th"
    else
      tmp = ""
    end
    num_str += tmp
    return num_str
  end
end

class Fixnum
  include FixnumExtensions
end

