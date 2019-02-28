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
    if (! @currentToken.kind.eql?(LOG_TOKEN_KINDS[:EOF]))
      raise 'Syntactic error'
    end
    puts 'Log file correctly parsed'
    return program_log_AST
  end

  def accept (expectedToken)
    if @currentToken.kind.eql? LOG_TOKEN_KINDS[expectedToken]
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
    while @currentToken.kind.eql? LOG_TOKEN_KINDS[:INTEGER] #First(Line)
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
    unit_AST = parse_unit
    return LogAST::Timestamp.new(time_value_AST, unit_AST)
  end

  def parse_unit
    unit = @currentToken.value.rstrip
    accept(:SEC) #Pour le moment
    return LogAST::Unit.new(unit)
  end

  def parse_integer
    time_value = @currentToken.value
    accept(:INTEGER)
    return LogAST::IntegerLiteral.new(time_value)
  end

  def parse_description
    identifier_AST = parse_identifier
    if @currentToken.value.eql?('move')
      type = LogAST::IntegerLiteral.new(nil)
    elsif @currentToken.value.eql?('data')
      type = LogAST::IntegerLiteral.new(nil)
    end
    if @currentToken.kind.eql?(LOG_TOKEN_KINDS[:UNARYACTION])
      description_AST = parse_unary_expression(type)
    elsif @currentToken.kind.eql?(LOG_TOKEN_KINDS[:BINARYACTION])
      description_AST = parse_binary_expression(type)
    else
      raise 'Syntactic error'
    end
    return LogAST::Description.new(identifier_AST, description_AST)
  end

  def parse_unary_expression type
    unary_action_AST = parse_unary_action(type)
    accept(:LPARENTHESIS)
    parameter_value_AST = parse_parameter
    accept(:RPARENTHESIS)
    return LogAST::UnaryExpression.new(unary_action_AST, parameter_value_AST)
  end

  def parse_binary_expression type
    binary_action_AST = parse_binary_action(type)
    accept(:LPARENTHESIS)
    parameter_1_AST = parse_parameter
    accept(:COMMA)
    parameter_2_AST = parse_parameter
    accept(:RPARENTHESIS)
    return LogAST::BinaryExpression.new(binary_action_AST, parameter_1_AST, parameter_2_AST)
  end

  def parse_unary_action type
    unary_action_kind = @currentToken.value.rstrip
    accept(:UNARYACTION)
    return LogAST::UnaryAction.new(unary_action_kind, type)
  end

  def parse_binary_action type
    binary_action_kind = @currentToken.value.rstrip
    accept(:BINARYACTION)
    return LogAST::BinaryAction.new(binary_action_kind, type)
  end

  def parse_parameters #unused
    parameter_value_AST = parse_parameter
    while @currentToken.kind.eql? LOG_TOKEN_KINDS[:COMMA]
      acceptIt
      parameter_value_bis_AST = parse_parameter
      parameter_value_AST = LogAST::SequentialParameter.new(parameter_value_AST, parameter_value_bis_AST)
    end
    return parameter_value_AST
  end

  def parse_parameter
    value = @currentToken.value
    parameter_ast = nil
    case @currentToken.kind
    when LOG_TOKEN_KINDS[:INTEGER]
      acceptIt
      parameter_ast = LogAST::IntegerLiteral.new(value)
    when LOG_TOKEN_KINDS[:IDENTIFIER] #to change to keyword
      acceptIt
      parameter_ast = AbstractSyntaxTree::Identifier.new(value)
    end
    return LogAST::Parameter.new(parameter_ast)
  end

  def parse_identifier
    value = @currentToken.value.rstrip
    accept(:IDENTIFIER)
    return AbstractSyntaxTree::Identifier.new(value)
  end
end



