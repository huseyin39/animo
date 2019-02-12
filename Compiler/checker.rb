require_relative 'symbol_table'

class Checker
  attr_accessor :symbol_table

  def initialize
    @symbol_table = SymbolTable.new
  end

  def visit_body body, arg
    body.lines.visit(self, nil)
    return nil
  end

  def visit_single_line single_line, arg
    single_line.timestamp.visit(self, nil)
    single_line.description.visit(self, nil)
    return nil
  end

  def visit_sequential_line sequential_line, arg
    sequential_line.line1.visit(self, nil)
    sequential_line.line2.visit(self, nil)
    return nil
  end

  def visit_timestamp timestamp, arg
    timestamp.integer.visit(self, arg)
    timestamp.unit.visit(self, arg)
    return nil
  end

  def visit_integer integer, arg
    return integer
  end

  def visit_unit unit, arg
    puts unit.value
    return nil
  end

  def visit_description description, arg
    description.identifier.visit(self, arg)
    description.expression.visit(self, arg)
    return nil
  end


  def visit_unary_expression unary_expression, arg
    type_unary_expression = unary_expression.unary_action.visit(self, arg)
    type_arg = unary_expression.arg.visit(self, arg)
    if (! (type_arg == type_unary_expression) )
      raise 'type of argument must be ' + type_arg.to_s
    end
    return unary_expression.type
  end

  def visit_binary_expression binary_expression, arg
    type_binary_expression = binary_expression.binary_action.visit(self, arg)
    type_arg1 = binary_expression.arg1.visit(self, arg)
    type_arg2 = binary_expression.arg2.visit(self, arg)
    if (! (type_arg1 == type_binary_expression) )
      raise 'type of argument1 must be ' + type_arg.to_s
    elsif (! (type_arg2 == type_binary_expression) )
      raise 'type of argument2 must be ' + type_arg.to_s
    end
    return binary_expression.type
  end

  def visit_unary_action unary_action, arg
    return unary_action.type
  end


  def visit_binary_action binary_action, arg
    return binary_action.type
  end

  def visit_parameter_value parameter_value, arg #to remove ?
    return nil
  end

  def visit_single_declaration single_declaration, arg
    @symbol_table.insert(single_declaration.identifier, single_declaration)
  end

  def visit_identifier id, arg
    id.declaration = @symbol_table.retrieve(id.value)
    return id.declaration
  end
end