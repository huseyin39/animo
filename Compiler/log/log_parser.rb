require_relative 'log_scanner'
require_relative 'log_AST'

class LogParser
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
    accept(:BEGIN)
    body_AST = parse_body
    accept(:END)
    return LogAST::Program.new(body_AST)
  end

  def parse_body
    line_AST = parse_line
    accept(:SEMICOLON)
    while @currentToken.kind.eql? TOKEN_KINDS[:INTEGER] #First(Line)
      line_bis_AST = parse_line
      accept(:SEMICOLON)
      line_AST = LogAST::SequentialLine.new(line_AST, line_bis_AST)
    end
    return line_AST
  end

  def parse_line
    timestamp_AST = parse_timestamp
    accept(:COLON)
    description_AST = parse_description
    return LogAST::SingleLine.new(timestamp_AST, description_AST)
  end

  def parse_timestamp
    time_value_AST = parse_integer
    unit = @currentToken.value
    accept(:SEC) #Pour le moment
    return LogAST::Timestamp.new(time_value_AST, unit)
  end

  def parse_integer
    time_value = @currentToken.value
    accept(:INTEGER)
    return LogAST::Integer.new(time_value)
  end

  def parse_description
    identifier_AST = parse_identifier
    action_AST = parse_action
    accept(:LPARENTHESIS)
    if @currentToken.kind.eql?TOKEN_KINDS[:INTEGER]
      parameter_AST = parse_parameters
    end
    accept(:RPARENTHESIS)
    return LogAST::Description.new(identifier_AST, action_AST, parameter_AST)
  end

  def parse_action
    action = @currentToken.value
    accept(:ACTION)
    return LogAST::Action.new(action)

  end

  def parse_parameters
    parameter_value_AST = parse_parameter_value
    while @currentToken.kind.eql? TOKEN_KINDS[:COMMA]
      acceptIt
      parameter_value_bis_AST = parse_parameter_value
      parameter_value_AST = LogAST::SequentialParameter.new(parameter_value_AST, parameter_value_bis_AST)
    end
    return parameter_value_AST
  end

  def parse_parameter_value
    value = @currentToken.value
    #accept(:PARAMETERVALUE) to change in log_scanner as well to be able to determine ...
    accept(:INTEGER)
    return LogAST::ParameterValue.new(value)
  end

  def parse_identifier
    value = @currentToken.value
    accept(:IDENTIFIER)
    return LogAST::Identifier.new(value)
  end
end



