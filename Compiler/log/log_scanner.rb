require_relative 'log_token'

class Scanner

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
      @current_char = file.readchar # method to get next char
    else
      raise 'Lexical Error'
    end
  end

  def takeIt
    @current_value << @current_char
    @current_char = @file.readchar # method to get next char
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
    puts "Kind : #{@current_kind} value : #{@current_value.string}"
    return Token.new(@current_kind, @current_value.string)
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
      return TOKEN_KINDS[:INTEGER]
    end


    if is_letter?(@current_char)
      takeIt
      while is_letter?(@current_char) || is_numeric?(@current_char) || @current_char === '_'
        takeIt
      end
      return TOKEN_KINDS[:IDENTIFIER]
    end


    case @current_char
    when '='
      takeIt
      return TOKEN_KINDS[:EQUAL]

    when ';'
      takeIt
      return TOKEN_KINDS[:SEMICOLON]

    when ','
      takeIt
      return TOKEN_KINDS[:COMMA]

    when '"'
      takeIt
      return TOKEN_KINDS[:DOUBLEQUOTE]
    end
  end
end



s = StringIO.new
s << 'a'
s << 'b'
#puts s.string