require_relative 'object_token'

class ObjectScanner
  def initialize file
    @file = file
    @current_char = file.readchar # fetch the first char
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

  def scan_string
    string = ""
    if @current_char.eql?('}')
      fetch_next_char
      if @current_char.eql?('}')
        fetch_next_char
        return ""
      else
        string << "{"
        string << scan_string
      end
    end
    string << @current_char
    fetch_next_char
    string << scan_string
  end

  def scan_token
    if @current_char =~ /[a-zA-Z]/
      takeIt
      while @current_char =~ /\w/
        takeIt
      end
      return OBJECT_TOKEN_KINDS[:IDENTIFIER]
    end

    case @current_char
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
      fetch_next_char
      if @current_char.eql?('{')
        fetch_next_char
        string = scan_string
        @current_value << string
        return OBJECT_TOKEN_KINDS[:INSTRUCTIONS]
      else
        raise 'Unexpected character: {. YOu meant {{?'
      end

    when '$$'
      return OBJECT_TOKEN_KINDS[:EOF]
    end

    raise "Unexpected character: #{@current_char}"
  end
end