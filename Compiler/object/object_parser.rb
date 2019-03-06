require_relative 'object_AST'
require_relative '../AST'

class ObjectParser
  attr_accessor :scanner, :currentToken

  def initialize scanner
    @scanner = scanner
  end

  def parse_object
    @currentToken = @scanner.scan
    program_object_AST = parse_program_object
    if (! @currentToken.kind.eql?(OBJECT_TOKEN_KINDS[:EOF]))
      raise 'Syntactic error'
    end
    puts 'Object file correctly parsed'
    return program_object_AST
  end

  def accept (expectedToken)
    if @currentToken.kind.eql?(OBJECT_TOKEN_KINDS[expectedToken])
      @currentToken = @scanner.scan
    else
      puts @currentToken.kind
      raise 'Syntactic error'
    end
  end

  def acceptIt
    @currentToken = @scanner.scan
  end

  def parse_program_object
    object_AST = parse_command
    while @currentToken.kind.eql?(OBJECT_TOKEN_KINDS[:DESCRIPTION]) || @currentToken.kind.eql?(OBJECT_TOKEN_KINDS[:ANIMATION])
      object_AST2 = parse_command
      object_AST = ObjectAST::SequentialCommand.new(object_AST, object_AST2)
    end
    return object_AST
  end

  def parse_command
    if @currentToken.kind.eql?(OBJECT_TOKEN_KINDS[:DESCRIPTION])
      acceptIt
      return parse_description
    elsif @currentToken.kind.eql?(OBJECT_TOKEN_KINDS[:ANIMATION])
      acceptIt
      return parse_animation
    else
      raise 'Error'
    end
  end

  def parse_description
    object_ID_AST = parse_identifier
    accept(:LDOUBLEBRACKET)
    expression_AST = parse_expression
    accept(:RDOUBLEBRACKET)
    return ObjectAST::DescriptionCommand.new(object_ID_AST, expression_AST)
  end

  def parse_animation
    object_ID_AST = parse_identifier
    action_ID_AST = parse_identifier
    parameters_AST = parse_formal_parameter
    accept(:LDOUBLEBRACKET)
    expression_AST = parse_expression
    accept(:RDOUBLEBRACKET)
    return ObjectAST::AnimationCommand.new(object_ID_AST, action_ID_AST, parameters_AST, expression_AST)
  end


  def parse_expression
    value = ''
    while !(@currentToken.kind.eql?(OBJECT_TOKEN_KINDS[:RDOUBLEBRACKET]))
      value << @currentToken.value
      acceptIt
    end
    return ObjectAST::Expression.new(value)
  end

  def parse_identifier
    value = @currentToken.value
    accept(:IDENTIFIER)
    return AbstractSyntaxTree::Identifier.new(value)
  end

  def parse_formal_parameter
    accept(:LPARENTHESIS)
    if @currentToken.kind.eql?(OBJECT_TOKEN_KINDS[:RPARENTHESIS])
      acceptIt
      return ObjectAST::FormalParameter.new(nil)
    else
      parameters_AST = parse_proper_formal_parameter
      accept(:RPARENTHESIS)
      return ObjectAST::FormalParameter.new(parameters_AST)
    end
  end


  def parse_proper_formal_parameter
    parameter_AST = ObjectAST::ProperFormalParameter.new(parse_identifier)
    if @currentToken.kind.eql?(OBJECT_TOKEN_KINDS[:COMMA])
      acceptIt
      parameter_AST2 = parse_proper_formal_parameter
      return ObjectAST::ProperFormalParameterSequence.new(parameter_AST, parameter_AST2)
    end
    return parameter_AST
  end
end