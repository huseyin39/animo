class Lexer
  def initialize
    @current_char # = fetch the first char

    #Current token
    @current_kind = nil
    @current_value = StringIO.new #StringBuffer
  end

  def take(expected_character)
    if @current_char.eql?(expected_character)
      @current_value << @current_char
      @current_char  # = method to get next char
    else
      raise 'Lexical Error'
    end
  end

  def takeIt
    @current_value << @current_char
    @current_char  # = method to get next char
  end

  def letter?(character)
    character =~ /[[:alpha:]]/
  end

  def numeric?(lookAhead)
    lookAhead =~ /[[:digit:]]/
  end

  def scan_separator
    case @current_char
    when "\n", "\r\n", ' '
      takeIt
    end
  end

  def scan_token

  end

end


aa = Lexer.new
puts aa.letter?'u'
if aa.letter?'4' #return nil
  puts 'oui'
end
puts aa.numeric?'4'

s = StringIO.new
s << 'a'
s << 'b'
puts s.string
print "\r\n"
print '4'