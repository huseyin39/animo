class ObjectParser
  attr_accessor :scanner, :currentToken

  def initialize scanner
    @scanner = scanner
  end

  def parse
    @currentToken = @scanner.scan
    program_AST = parse_program
  end

  def accept (expectedToken)
    if @currentToken.kind.eql? TOKEN_KINDS[expectedToken]
      @currentToken = @scanner.scan
    else
      raise 'Syntactic error'
    end
  end

  def acceptIt
    @currentToken = @scanner.scan
  end

  def parse_program
    parse_line
    accept(:SEMICOLON)
    while @currentToken.kind.eql?(:IDENTIFIER)
      parse_line
      accept(:SEMICOLON)
    end
  end

  def parse_line
    parse_identifier
    accept(:EQUAL)
    parse_type
    accept(:COMMA)
    accept(:DOUBLEQUOTE)
    parse_filename
    accept(:DOUBLEQUOTE)
  end

  def parse_type
    accept(:TYPE)
  end

  def parse_filename
    accept(:FILENAME)
  end

  def parse_identifier
    accept(:IDENTIFIER)
  end

end