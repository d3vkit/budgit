module StringExtensions
  def continuous
    if self == "week" || self == "month" || self == "hour" || self == "year"
      return self + 'ly'
    elsif self == "day"
      return "daily"
    else
      return self
    end
  end

  def uncontinuous
    if self == "daily"
      return "day"
    elsif self =~ /[a-z]+ly/
      return self.gsub!('ly','')
    else
      return self
    end
  end

  def numbereth
    if self =~ /[a-z]+teen/
      return self + 'th'
    elsif self =~ /([a-z]+ty)/
      return self.gsub!('y','ieth')
    else
      return self
    end
  end

  def denumbereth
    if self =~ /[a-z]+eenth/
      return self.gsub!('eenth','teen')
    elsif self =~ /[a-z]+ieth/
      return self.gsub!('ieth','y')
    else
      return self
    end
  end

  def words_to_numbers
    #works on numbers as words seperated by spaces - string = "one hundred and forty nine"
    number = ''
    ends_in_y = false

    new_self = self.gsub('-',' ').downcase

    split_words = new_self.split(' ')
    split_words.each do |word|
      if word =~ /zero/
        tmp = 0
      elsif word =~ /one/ || word =~ /first/
        tmp = 1
      elsif word =~ /two/ || word =~ /second/
        tmp = 2
      elsif word =~ /three/ || word =~ /third/
        tmp = 3
      elsif word =~ /four/ || word =~ /fourth/
        tmp = 4
      elsif word =~ /five/ || word =~ /fifth/
        tmp = 5
      elsif word =~ /six/ || word =~ /sixth/
        tmp = 6
      elsif word =~ /seven/ || word =~ /seventh/
        tmp = 7
      elsif word =~ /eight/ || word =~ /eight/
        tmp = 8
      elsif word =~ /nine/ || word =~ /ninth/
        tmp = 9
      elsif word =~ /ten/ || word =~ /tenth/
        tmp = 10
      elsif word =~ /eleven/ || word =~ /eleventh/
        tmp = 11
      elsif word =~ /twelve/ || word =~ /twelfth/
        tmp = 12
      elsif word.denumbereth =~ /thirteen/
        tmp = 13
      elsif word.denumbereth =~ /fourteen/
        tmp = 14
      elsif word.denumbereth =~ /fifteen/
        tmp = 15
      elsif word.denumbereth =~ /sixteen/
        tmp = 16
      elsif word.denumbereth =~ /seventeen/
        tmp = 17
      elsif word.denumbereth =~ /eighteen/
        tmp = 18
      elsif word.denumbereth =~ /nineteen/
        tmp = 19
      elsif word.denumbereth =~ /twenty/
        tmp,ends_in_y = 20,true
      elsif word.denumbereth =~ /thirty/
        tmp,ends_in_y = 30,true
      elsif word.denumbereth =~ /forty/
        tmp,ends_in_y = 40,true
      elsif word.denumbereth =~ /fifty/
        tmp,ends_in_y = 50,true
      elsif word.denumbereth =~ /sixty/
        tmp,ends_in_y = 60,true
      elsif word.denumbereth =~ /seventy/
        tmp,ends_in_y = 70,true
      elsif word.denumbereth =~ /eighty/
        tmp,ends_in_y = 80,true
      elsif word.denumbereth =~ /ninety/
        tmp,ends_in_y = 90,true
      else
        tmp = ''
      end

      if word != split_words.last && ends_in_y
        tmp = tmp.to_s.gsub!('0','')
      elsif word == split_words.last
        if word =~ /hundred/
          tmp = "00"
        elsif word =~ /thousand/
          tmp = "000"
        elsif word =~ /million/
          tmp = "000000"
        end
      end

      number += tmp.to_s
      ends_in_y = false
    end
    return number
  end
end


class String
  include StringExtensions
end

