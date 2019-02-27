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
      raise 'Syntactic error'
    end
  end

  def acceptIt
    @currentToken = @scanner.scan
  end

  def parse_program_object
    declaration_AST = parse_declaration
    accept(:SEMICOLON)
    while @currentToken.kind.eql?(OBJECT_TOKEN_KINDS[:IDENTIFIER])
      declaration_AST2 = parse_declaration
      accept(:SEMICOLON)
      declaration_AST = ObjectAST::SequentialDeclaration.new(declaration_AST, declaration_AST2)
    end
    return ObjectAST::ProgramObject.new(declaration_AST)
  end

  def parse_declaration
    identifier_AST = parse_identifier
    accept(:EQUAL)
    type_AST = parse_type
    accept(:COMMA)
    accept(:DOUBLEQUOTE)
    filename_AST = parse_filename
    accept(:DOUBLEQUOTE)
    return ObjectAST::SingleDeclaration.new(identifier_AST, type_AST, filename_AST)
  end

  def parse_type
    value = @currentToken.value.rstrip
    accept(:TYPE)
    return ObjectAST::Type.new(value)
  end

  def parse_filename
    value = @currentToken.value.rstrip
    accept(:FILENAME)
    return ObjectAST::Filename.new(value)
  end

  def parse_identifier
    value = @currentToken.value.rstrip
    accept(:IDENTIFIER)
    return AbstractSyntaxTree::Identifier.new(value)
  end

end