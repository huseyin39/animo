require_relative 'log_scanner'
require_relative 'log_AST'

class LogParser
  attr_accessor :scanner, :currentToken

  def initialize scanner
    @scanner = scanner
  end

  def parse_log
    @currentToken = @scanner.scan
    program_log_AST = parse_program_log
    return program_log_AST
  end

  def accept (expectedToken)
    puts currentToken.kind
    puts currentToken.value
    if @currentToken.kind.eql? TOKEN_KINDS[expectedToken]
      @currentToken = @scanner.scan
    else
      raise 'Syntactic error'
    end
  end

  def acceptIt
    @currentToken = @scanner.scan
  end

  def parse_program_log
    accept(:BEGIN)
    body_AST = parse_body
    accept(:END)
    return LogAST::ProgramLog.new(body_AST)
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
    if @currentToken.value.eql?('move')
      type = LogAST::Integer.new(nil)
    end
    if @currentToken.kind.eql?(TOKEN_KINDS[:UNARYACTION])
      description_AST = parse_unary_expression(type)
    elsif @currentToken.kind.eql?(TOKEN_KINDS[:BINARYACTION])
      description_AST = parse_binary_expression(type)
    else
      raise 'Syntactic error'
    end
    return LogAST::Description.new(identifier_AST, description_AST)
  end

  def parse_unary_expression type
    unary_action_AST = parse_unary_action(type)
    accept(:LPARENTHESIS)
    parameter_value_AST = parse_parameter_value
    accept(:RPARENTHESIS)
    return LogAST::UnaryExpression.new(unary_action_AST, parameter_value_AST)
  end

  def parse_binary_expression type
    binary_action_AST = parse_binary_action(type)
    accept(:LPARENTHESIS)
    parameter_1_AST = parse_parameter_value
    accept(:COMMA)
    parameter_2_AST = parse_parameter_value
    accept(:RPARENTHESIS)
    return LogAST::BinaryExpression.new(binary_action_AST, parameter_1_AST, parameter_2_AST)
  end

  def parse_unary_action type
    unary_action = @currentToken.value
    accept(:UNARYACTION)
    return LogAST::UnaryAction.new(unary_action, type)
  end

  def parse_binary_action type
    binary_action = @currentToken.value
    accept(:BINARYACTION)
    return LogAST::BinaryAction.new(binary_action, type)
  end

  def parse_parameters #unused
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
    case @currentToken.kind
    when :INTEGER
      return LogAST::Integer.new(value)

    when :STRING
      return LogAST::String.new(value)
    end
    raise 'Type Error'
  end

  def parse_identifier
    value = @currentToken.value
    accept(:IDENTIFIER)
    return AbstractSyntaxTree::Identifier.new(value)
  end
end



