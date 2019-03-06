require_relative 'object_token'

class ObjectScanner
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
      @current_char = '$$'
    else
      @current_char = @file.readchar # method to get next char
    end
  end

  def is_letter?(lookAhead)
    lookAhead =~ /[[:alpha:]]/
  end

  def is_numeric?(lookAhead)
    lookAhead =~ /\d/
  end

  def scan
    while @current_char =~ /[[:space:]]/
      takeIt
    end
    @current_value = StringIO.new
    @current_kind = scan_token
    #puts "Object : Kind : #{@current_kind} value : #{@current_value.string}"
    return ObjectToken.new(@current_kind, @current_value.string)
  end

  def scan_token
    # if is_numeric?(@current_char) #Integer
    #   takeIt
    #   while is_numeric?(@current_char)
    #     takeIt
    #   end
    #   return OBJECT_TOKEN_KINDS[:INTEGER]
    # end

    if @current_char =~ /[a-zA-Z]/
      takeIt
      while @current_char =~ /\w/
        takeIt
      end
      return OBJECT_TOKEN_KINDS[:IDENTIFIER]
    end

    case @current_char
    when ';'
      takeIt
      return OBJECT_TOKEN_KINDS[:SEMICOLON]

    when ','
      takeIt
      return OBJECT_TOKEN_KINDS[:COMMA]

    when ')'
      takeIt
      return OBJECT_TOKEN_KINDS[:RPARENTHESIS]

    when '('
      takeIt
      return OBJECT_TOKEN_KINDS[:LPARENTHESIS]

    when '{'
      takeIt
      if @current_char.eql?('{')
        takeIt
        return OBJECT_TOKEN_KINDS[:LDOUBLEBRACKET]
      else
        return OBJECT_TOKEN_KINDS[:CHAR]
      end

    when '}'
      takeIt
      if @current_char.eql?('}')
        takeIt
        return OBJECT_TOKEN_KINDS[:RDOUBLEBRACKET]
      else
        return OBJECT_TOKEN_KINDS[:CHAR]
      end
    end

    if @current_char.eql?('$$')
      return OBJECT_TOKEN_KINDS[:EOF]
    end

    takeIt
    return OBJECT_TOKEN_KINDS[:CHAR]
  end
end