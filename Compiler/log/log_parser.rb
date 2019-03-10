require_relative 'log_scanner'
require_relative 'log_AST'

class LogParser
  attr_accessor :scanner, :currentToken

  def initialize scanner
    @scanner = scanner
  end

  def parse_log
    @currentToken = @scanner.scan_log
    program_log_AST = parse_program_log
    if (! @currentToken.kind.eql?(LOG_TOKEN_KINDS[:EOF]))
      raise 'Syntactic error'
    end
    puts 'Log file correctly parsed'
    return program_log_AST
  end

  def accept (expectedToken)
    if @currentToken.kind.eql? LOG_TOKEN_KINDS[expectedToken]
      @currentToken = @scanner.scan_log
    else
      raise 'Syntactic error'
    end
  end

  def acceptIt
    @currentToken = @scanner.scan_log
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
    call_command_AST = parse_call_command
    return LogAST::SingleLine.new(timestamp_AST, call_command_AST)
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

  def parse_call_command
    object_id_AST = parse_identifier
    action_id_AST = parse_identifier
    actual_parameters_AST = parse_actual_parameter
    return LogAST::CallCommand.new(object_id_AST, action_id_AST, actual_parameters_AST)
  end

  def parse_actual_parameter
    accept(:LPARENTHESIS)
    if @currentToken.kind.eql?(LOG_TOKEN_KINDS[:RPARENTHESIS])
      acceptIt
      return LogAST::ActualParameter.new(nil)
    else
      parameters_AST = parse_proper_actual_parameter
      accept(:RPARENTHESIS)
      return LogAST::ActualParameter.new(parameters_AST)
    end
  end

  def parse_proper_actual_parameter
    parameter_AST = LogAST::ProperActualParameter.new(parse_parameter)
    if @currentToken.kind.eql?(LOG_TOKEN_KINDS[:COMMA])
      acceptIt
      parameter_AST2 = parse_proper_actual_parameter
      return LogAST::ProperActualParameterSequence.new(parameter_AST, parameter_AST2)
    end
    return parameter_AST
  end

  def parse_parameter
    case @currentToken.kind
    when LOG_TOKEN_KINDS[:LSTRING]
      acceptIt
      string_AST = parse_string
      accept(:RSTRING)
      return string_AST
    # when LOG_TOKEN_KINDS[:IDENTIFIER] #is it normal?
    #   id_AST =  parse_identifier
    #   return id_AST
    when LOG_TOKEN_KINDS[:INTEGER]
      int_AST = parse_integer
      return int_AST
    end

    raise 'Unexepcted parameter type'
  end

  def parse_string
    value = ''
    while !(@currentToken.kind.eql?(OBJECT_TOKEN_KINDS[:RSTRING]))
      value << @currentToken.value
      acceptIt
    end
    return LogAST::String.new(value)
  end

  def parse_int
    value = @currentToken.value.rstrip
    accept(:INTEGER)
    return LogAST::IntegerLiteral.new(value)
  end

  def parse_identifier
    value = @currentToken.value.rstrip
    accept(:IDENTIFIER)
    return AbstractSyntaxTree::Identifier.new(value)
  end
end



