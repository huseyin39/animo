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
    if @currentToken.kind.eql?(OBJECT_TOKEN_KINDS[:DESCRIPTION])
      takeIt
      parse_description
    elsif @currentToken.kind.eql?(OBJECT_TOKEN_KINDS[:ANIMATION])
      takeIt
      parse_animation
    else
      raise 'Error'
    end

  end

  def parse_description
    declaration_AST = parse_declaration
    # accept(:SEMICOLON)
    while @currentToken.kind.eql?(OBJECT_TOKEN_KINDS[:CONST]) || @currentToken.kind.eql?(OBJECT_TOKEN_KINDS[:FUNCTION])
      declaration_AST2 = parse_declaration
      # accept(:SEMICOLON)
      declaration_AST = ObjectAST::SequentialDeclaration.new(declaration_AST, declaration_AST2)
    end
    return ObjectAST::DeclarationBlock.new(declaration_AST)
  end

  def parse_declaration
    case @currentToken.kind
    when OBJECT_TOKEN_KINDS[:CONST]
      identifier_AST, parameters_AST, string_AST = parse_declaration_bis
      return ObjectAST::ConstDeclaration.new(identifier_AST, parameters_AST, string_AST)
    when OBJECT_TOKEN_KINDS[:FUNCTION]
      identifier_AST, parameters_AST, string_AST = parse_declaration_bis
      return ObjectAST::FunctionDeclaration(identifier_AST, parameters_AST, string_AST)
    end
    raise "Expected token: declaration or function; found #{@currentToken.kind}"
  end

  def parse_declaration_bis
    acceptIt
    identifier_AST = parse_identifier
    accept(:LPARENTHESIS)
    parameters_AST = parse_formal_parameter
    accept(:RPARENTHESIS)
    string_AST = parse_string
    return identifier_AST, parameters_AST, string_AST
  end

  def parse_animation
    assignment_AST = parse_assignment
    accept(:SEMICOLON)
    while @currentToken.kind.eql?(OBJECT_TOKEN_KINDS[:IDENTIFIER])
      assignment_AST2 = parse_assignment
      accept(:SEMICOLON)
      declaration_AST = ObjectAST::SequentialAssignment.new(declaration_AST, declaration_AST2)
    end
    return ObjectAST::AssignmentBlock.new(declaration_AST)
  end

  def parse_assignment
    identifier_object_AST = parse_identifier
    accept(:EQUAL)
    identifier_operator_AST = parse_identifier
    accept(:LPARENTHESIS)
    parameters_AST = parse_actual_parameter
    accept(:RPARENTHESIS)
    return ObjectAST::Assignment(identifier_object_AST, identifier_operator_AST, parameters_AST)
  end

  def parse_string
    value = @currentToken.value.rstrip
    accept(:STRING)
    return ObjectAST::String.new(value)
  end

  def parse_identifier
    value = @currentToken.value.rstrip
    accept(:IDENTIFIER)
    return AbstractSyntaxTree::Identifier.new(value)
  end

  def parse_formal_parameter
    if @currentToken.kind.eql?(OBJECT_TOKEN_KINDS[:RPARENTHESIS])
      return AST::FormalParameter.new(nil)
    else
      parameters_AST = parse_proper_formal_parameter
    end
  end

  def parse_proper_formal_parameter
    parameter_AST = parse_identifier
    if @currentToken.kind.eql?(OBJECT_TOKEN_KINDS[:COMMA])
      acceptIt
      parameter_AST2 = parse_proper_formal_parameter
      return AbstractSyntaxTree::ProperFormalParameterSequence.new(parameter_AST, parameter_AST2)
    end
    return AbstractSyntaxTree::ProperFormalParameter.new(parameter_AST)
  end
end