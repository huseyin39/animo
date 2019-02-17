require_relative 'symbol_table'
require_relative 'log/log_AST'

class CodeGenerator
  attr_accessor :symbol_table

  def initialize
    @symbol_table = SymbolTable.new
    @current_time = nil
  end

  def generate ast
    ast.visit(self, nil)
    return nil
  end

  def visit_program program, arg
    # program.program_object.visit(self, nil) useless for code generation
    program.program_log.visit(self, nil)
    return nil
  end

  def visit_program_log program_log, arg
    program_log.body.visit(self, nil)
    return nil
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
    temp_time = timestamp.integer.visit(self, arg).value.to_i
    timestamp.unit.visit(self, arg)
    return nil
  end

  def visit_integer integer, arg
    return integer
  end

  def visit_unit unit, arg
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
    return nil
  end

  def visit_binary_expression binary_expression, arg
    type_binary_expression = binary_expression.binary_action.visit(self, arg)
    type_arg1 = binary_expression.arg1.visit(self, arg)
    type_arg2 = binary_expression.arg2.visit(self, arg)
    return nil
  end

  def visit_unary_action unary_action, arg
    return unary_action.type
  end


  def visit_binary_action binary_action, arg
    return binary_action.type
  end

  def visit_parameter parameter, arg
    return parameter.parameter_ast.visit(self, nil)
  end


  def visit_program_object program_object, arg
    program_object.declarations.visit(self, nil)
  end


  def visit_sequential_declaration sequential_declaration, arg
    sequential_declaration.declaration1.visit(self, nil)
    sequential_declaration.declaration2.visit(self, nil)
  end

  def visit_single_declaration single_declaration, arg
    @symbol_table.insert(single_declaration.identifier.value, single_declaration)
  end

  def visit_identifier id, arg
    id.declaration = @symbol_table.retrieve(id.value)
    if (id.declaration.nil?)
      raise "#{id.value} has not been initialized"
    else
      return id.declaration
    end
  end
end