require 'log_lexer'

class Log_parser

  def initialize
    @currentToken = scan()
  end

  def accept (expectedToken)

  end

  def acceptIt
    @currentToken = scan()
  end

  def parse_program
    accept(TOKEN_KINDS[:BEGIN])
    parse_body
    accept(TOKEN_KINDS[:END])
  end

  def parse_body
    parse_line
    while @currentToken.kind.eql? #First(Line)
      parse_line
    end
  end

  def parse_line
    parse_identifier
    parse_action
    accept(TOKEN_KINDS[:LPARENTHESIS])
    parse_parameter
  end

  def parse_identifier
    parse_parameter_value
    while @currentToken.kind.eql? TOKEN_KINDS[:CHARLITERAL] || TOKEN_KINDS[:INTLITERAL] || TOKEN_KINDS[:UNDERSCORE]
      puts 4
    end
  end

  def parse_action

  end

  def parse_parameter
    parse_parameter_value
    while @currentToken.kind.eql? TOKEN_KINDS[:COMMA]
      acceptIt
      parse_parameter_value
    end
  end

  def parse_parameter_value

  end

  def parse_integer_literal
    if @currentToken.kind.eql?TOKEN_KINDS[:INTLITERAL]
      #value = @currentToken.value
      @currentToken = scan()
    end
  end

    def parse_character_literal
      if @currentToken.kind.eql?TOKEN_KINDS[:CHARLITERAL]
        #value = @currentToken.value
        @currentToken = scan()
      end
    end

end