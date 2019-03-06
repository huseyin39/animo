require_relative 'symbol_table'
require_relative 'log/log_AST'

class Checker
  attr_accessor :symbol_table, :current_time, :type

  def initialize
    @symbol_table = SymbolTable.new
    @current_time = nil
    @type = nil
  end

  def check ast
    ast.accept(self, nil)
    return type
  end

  def visit_program program, arg
    program.program_object.accept(self, nil)
    puts @symbol_table.to_s
    program.program_log.accept(self, nil)
    return nil
  end

  def visit_program_log program_log, arg
    program_log.body.accept(self, nil)
    return nil
  end

  def visit_body body, arg
    body.lines.accept(self, nil)
    return nil
  end

  def visit_single_line single_line, arg
    single_line.timestamp.accept(self, nil)
    single_line.description.accept(self, nil)
    return nil
  end

  def visit_sequential_line sequential_line, arg
    sequential_line.line1.accept(self, nil)
    sequential_line.line2.accept(self, nil)
    return nil
  end

  def visit_timestamp timestamp, arg
    temp_time = timestamp.integer.accept(self, arg).to_i
    if (@current_time.nil?)
      @current_time = temp_time
    elsif (temp_time < @current_time)
      raise 'Error: Time must be increasing'
    else
      @current_time = temp_time
    end
    timestamp.unit.accept(self, arg)
    return nil
  end

  def visit_integer integer, arg
    return integer.value
  end

  def visit_unit unit, arg
    return nil
  end

  def visit_call_command command, arg
    object_id = command.object_id.accept(self, nil)
    action_id = command.action_id.accept(self, nil)
    number_actual_parameter = command.actual_parameter.accept(self, nil)
    number_formal_parameters = @symbol_table.retrieve(object_id, action_id)
    if number_formal_parameters.nil?
      raise "The animation #{action_id} has not been declared for the object #{object_id} in the object file"
    elsif number_actual_parameter != number_formal_parameters
      raise "The animation #{action_id} requires #{number_formal_parameters} parameters, #{number_actual_parameter} were given"
    else
      return nil
    end
  end

  def visit_actual_parameter actual_parameter, arg
    number_parameters = actual_parameter.parameters.accept(self, nil)
  end

  def visit_proper_actual_parameter proper_actual_parameter, arg
    proper_actual_parameter.parameter.accept(self, nil)
    return 1
  end

  def visit_proper_actual_parameter_sequence proper_actual_parameter_sequence, arg
    length = 0
    length += proper_actual_parameter_sequence.parameter1.accept(self, nil)
    length += proper_actual_parameter_sequence.parameter2.accept(self, nil)
    return length
  end

  def visit_parameter parameter, arg
    return parameter.parameter_ast.accept(self, nil)
  end


  def visit_program_object program_object, arg
    program_object.command.accept(self, nil)
  end


  def visit_sequential_command sequential_command, arg
    sequential_command.command1.accept(self, nil)
    sequential_command.command2.accept(self, nil)
  end

  def visit_animation_command animation_command, arg
    object_id = animation_command.object_ID.accept(self, nil)
    action_id = animation_command.action_ID.accept(self, nil)
    fps = animation_command.formal_parameters_sequence.accept(self, nil)
    expression = animation_command.expression.accept(self, nil)
    @symbol_table.insert(object_id, {action_id => [fps, expression]})
  end

  def visit_description_command description_command, arg
    description_command.expression.accept(self, nil)
    object_id = description_command.object_ID.accept(self, nil)
  end

  def visit_expression expression, arg
    if expression.value.length == 0
      raise 'Expression is empty'
    else
      return expression.value
    end
  end

  def visit_formal_parameter formal_parameter, arg
    number_parameters = formal_parameter.parameters.accept(self, nil)
    return number_parameters
  end

  def visit_proper_formal_parameter proper_formal_parameter, arg
    proper_formal_parameter.parameter.accept(self, nil)
    return 1
  end

  def visit_proper_formal_parameter_sequence proper_formal_parameter_sequence, arg
    length = 0
    length += proper_formal_parameter_sequence.parameter1.accept(self, nil)
    length += proper_formal_parameter_sequence.parameter2.accept(self, nil)
    return length
  end


  # def visit_type type, arg
  #   type_value = type.value
  #   case type_value
  #   when 'move', 'chart'
  #     if (@type.nil?)
  #       @type = type_value
  #       return type_value
  #     elsif (@type == type_value)
  #       return type_value
  #     else
  #       raise "One type per object file. '#{@type}' and '#{type_value}' found"
  #     end
  #   end
  #   raise "#{type_value} is not recognized"
  # end

  def visit_identifier id, arg
    return id.value
  end

  def visit_string string, arg
    return string.value
  end

end