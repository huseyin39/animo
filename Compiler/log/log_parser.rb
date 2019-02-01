require 'log_lexer'

class LogParser

  def initialize
    @currentToken = scan()
    program_AST = parse_program
  end

  def accept (expectedToken)
    if @currentToken.kind.eql? TOKEN_KINDS[expectedToken]
      @currentToken = scan()
    else
      raise 'Syntactic error'
    end
  end

  def acceptIt
    @currentToken = scan()
  end

  def parse_program
    accept(:BEGIN)
    body_AST = parse_body
    accept(:END)
    return LogAST::Program(body_AST)
  end

  def parse_body
    line_AST = parse_line
    accept(:SEMICOLON)
    while @currentToken.kind.eql? TOKEN_KINDS[:IDENTIFIER] #First(Line)
      line_bis_AST = parse_line
      line_AST = LogAST::SequentialLine(line_AST, line_bis_AST)
    end
    return line_AST
  end

  def parse_line
    timestamp_AST = parse_timestamp
    description_AST = parse_description
    return LogAST::SingleLine(timestamp_AST, description_AST)
  end

  def parse_timestamp
    time_value_AST = parse_integer
    unit = @currentToken.value
    accept(:SEC) #Pour le moment
    return LogAST::Timestamp(time_value_AST, unit)
  end

  def parse_integer
    time_value = @currentToken.value
    accept(:INTEGER)
    return LogAST::TimeValue(time_value)
  end

  def parse_description
    identifier_AST = parse_identifier
    action_AST = parse_action
    accept(:LPARENTHESIS)
    parameter_AST = parse_parameters
    return LogAST::Description(identifier_AST, action_AST, parameter_AST)
  end

  def parse_action
    action = @currentToken.value
    accept(:ACTION)
    return LogAST::Action(action)

  end

  def parse_parameters
    parameter_value_AST = parse_parameter_value
    while @currentToken.kind.eql? TOKEN_KINDS[:COMMA]
      acceptIt
      parameter_value_bis_AST = parse_parameter_value
      parameter_value_AST = LogAST::SequentialParameter(parameter_value_AST, parameter_value_bis_AST)
    end
    return parameter_value_AST
  end

  def parse_parameter_value
    value = @currentToken.value
    accept(:PARAMETERVALUE)
    return LogAST::ParameterValue(value)
  end

  def parse_identifier
    value = @currentToken.value
    accept(:IDENTIFIER)
    return LogAST::Identifier(value)
  end

end

