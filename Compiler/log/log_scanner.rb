require_relative 'log_token'

class LogScanner

  def initialize file
    @file = file
    @current_char = file.readchar # fetch the first char

    #Current token
    @current_kind = nil
    @current_value = StringIO.new #StringBuffer
  end

  def take(expected_character)
    if @current_char.eql?(expected_character)
      @current_value << @current_char
      fetch_next_char
    else
      raise 'Lexical Error'
    end
  end

  def takeIt
    @current_value << @current_char
    fetch_next_char
  end

  def fetch_next_char
    if (@file.eof)
      @current_char = '$'
    else
      @current_char = @file.readchar # method to get next char
    end
  end

  def is_letter?(character)
    character =~ /[[:alpha:]]/
  end

  def is_numeric?(lookAhead)
    lookAhead =~ /[[:digit:]]/
  end

  def scan
    while @current_char == ' ' || @current_char == "\n" || @current_char == "\r" || @current_char == "\r\n"
      takeIt
    end
    @current_value = StringIO.new
    @current_kind = scan_token
    return LogToken.new(@current_kind, @current_value.string)
  end

  def scan_separator #is it used?
    case @current_char
    when "\n", "\r\n", ' ', "\r\n"
      takeIt
    end
  end

  def scan_token
    if is_numeric?(@current_char) #Integer
      takeIt
      while is_numeric?(@current_char)
        takeIt
      end
      return LOG_TOKEN_KINDS[:INTEGER]
    end


    if is_letter?(@current_char)
      takeIt
      while is_letter?(@current_char) || is_numeric?(@current_char) || @current_char === '_'
        takeIt
      end
      return LOG_TOKEN_KINDS[:IDENTIFIER]
    end


    case @current_char

    when ':'
    takeIt
    return LOG_TOKEN_KINDS[:COLON]

    when ';'
    takeIt
    return LOG_TOKEN_KINDS[:SEMICOLON]

    when ','
    takeIt
    return LOG_TOKEN_KINDS[:COMMA]

    when ')'
    takeIt
    return LOG_TOKEN_KINDS[:RPARENTHESIS]

    when '('
    takeIt
    return LOG_TOKEN_KINDS[:LPARENTHESIS]

    end


    if @current_char.eql?('$')
      return LOG_TOKEN_KINDS[:EOF]
    end

    raise 'Unexpected character'

  end
end



s = StringIO.new
s << 'a'
s << 'b'
#puts s.string