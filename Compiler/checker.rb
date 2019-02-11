require_relative 'symbol_table'

class Checker
  attr_accessor :symbol_table

  def initialize
    @symbol_table = SymbolTable.new
  end

  def visitBody body, arg
    body.lines.visit(self, nil)
    return nil
  end

  def visitSingleLine single_line, arg
    single_line.timestamp.visit(self, nil)
    single_line.description.visit(self, nil)
  end

  def visitSequentialLine sequential_line, arg
    sequential_line.line1.visit(self, nil)
    sequential_line.line2.visit(self, nil)
  end

  def visitTimestamp timestamp, arg
    timestamp.integer.visit(self, arg)
  end

  def visitDescription description, arg
    description.identifier.visit(self, arg)
    description.action.visit(self, arg)

  end


  def visitBinaryAction binary_action, arg

  end

  def visitUnaryAction unary_action, arg

  end


  def visitSingleDeclaration single_declaration, arg
    @symbol_table.insert(single_declaration.identifier, single_declaration)
  end

  def visitIdentifier id, arg
    id.declaration = @symbol_table.retrieve(id.value)
    return id.declaration
  end
end