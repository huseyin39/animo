require_relative 'symbol_table'
require_relative 'log/log_AST'

class Checker
  def initialize
    @symbol_table = SymbolTable.new
    @current_time = nil
  end

  def check ast
    ast.accept(self, nil)
    puts 'Contextual analysis done'
    return @symbol_table
  end

  def visit_program program, arg
    program.program_object.accept(self, nil)
    program.program_log.accept(self, nil)
    return nil
  end

  #--------------------------------------------------------------------------------------------------------------------
  # Object visit
  # -------------------------------------------------------------------------------------------------------------------

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
    fps, parameters_ID = animation_command.formal_parameters_sequence.accept(self, nil)
    instructions = animation_command.instructions.accept(self, nil)
    @symbol_table.insert(object_id, {action_id => [fps, parameters_ID, instructions]})
  end

  def visit_description_command description_command, arg
    description_command.instructions.accept(self, nil)
    description_command.object_ID.accept(self, nil)
  end

  def visit_instructions instructions, arg
    if instructions.value.length == 0
      raise 'Expression is empty'
    else
      return instructions.value
    end
  end

  def visit_formal_parameter formal_parameter, arg
    number_parameters = formal_parameter.parameters.accept(self, nil)
    return number_parameters
  end

  def visit_proper_formal_parameter proper_formal_parameter, arg
    parameter =  proper_formal_parameter.parameter.accept(self, nil)
    if parameter.eql?('t')
      raise 't cannot be used as a parameter'
    end
    return 1, [parameter]
  end

  def visit_proper_formal_parameter_sequence proper_formal_parameter_sequence, arg
    length = 0
    parameters = []
    len, param = proper_formal_parameter_sequence.parameter1.accept(self, nil)
    length += len
    parameters.push(*param)
    len, param = proper_formal_parameter_sequence.parameter2.accept(self, nil)
    length += len
    parameters.push(*param)
    return length, parameters
  end

  #--------------------------------------------------------------------------------------------------------------------
  # Log visit
  # -------------------------------------------------------------------------------------------------------------------

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
    unit = timestamp.unit.accept(self, arg)
    if unit.eql?('sec')
      temp_time = temp_time*1000
    elsif unit.eql?('msec')
    else
      raise 'Unknown unit'
    end
    if (@current_time.nil? || temp_time >= @current_time)
      @current_time = temp_time
    else
      raise 'Error: Time must be increasing'
    end
    return nil
  end

  def visit_call_command command, arg
    object_id = command.object_id.accept(self, nil)
    action_id = command.action_id.accept(self, nil)
    number_actual_parameter = command.actual_parameter.accept(self, nil)
    animation_information = @symbol_table.lookup(object_id, action_id)
    if animation_information.eql?('undefined')
      raise "The animation #{action_id} has not been declared for the object #{object_id} in the object file"
    elsif animation_information.nil?
      #It means no object ID so we do not do anything
    else
        number_formal_parameters = animation_information[0]
        if number_actual_parameter != number_formal_parameters
          raise "The animation #{action_id} requires #{number_formal_parameters} parameters, #{number_actual_parameter} were given"
        else
          return nil
        end
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

  #--------------------------------------------------------------------------------------------------------------------
  # Terminals visit
  # -------------------------------------------------------------------------------------------------------------------

  def visit_identifier id, arg
    return id.value
  end

  def visit_string string, arg
    return string.value
  end

  def visit_integer integer, arg
    return integer.value
  end

  def visit_unit unit, arg
    return unit.value
  end
end