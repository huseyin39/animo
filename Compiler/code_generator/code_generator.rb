class CodeGenerator
  def initialize filename, symbol_table
    @filename = filename
    @file = nil
    @symbol_table = symbol_table
    @current_time = 0
    @timestamps = Hash.new #{object_id: [t0, .... t-1, t]}
  end

  def generate ast
    begin
      path = File.join(File.dirname(__FILE__ ), "../res/" + @filename + ".animo")
      @file = File.new(path, 'w+')
      ast.accept(self, nil)
    ensure
      @file.close unless @file.nil?
    end
  end

  def visit_program program, arg
    program.program_object.accept(self, nil)
    #program.program_log.accept(self, nil)
    return nil
  end

  #--------------------------------------------------------------------------------------------------------------------

  def visit_program_object program_object, arg
    program_object.command.accept(self, nil)
  end

  def visit_sequential_command sequential_command, arg
    sequential_command.command1.accept(self, nil)
    sequential_command.command2.accept(self, nil)
  end

  def visit_animation_command animation_command, arg #unused in this part
    # object_id = animation_command.object_ID.accept(self, nil)
    # action_id = animation_command.action_ID.accept(self, nil)
    # fps, parameters_ID = animation_command.formal_parameters_sequence.accept(self, nil)
    # instructions = animation_command.instructions.accept(self, nil)
    # @symbol_table.insert(object_id, {action_id => [fps, parameters_ID, instructions]})
  end

  def visit_description_command description_command, arg
    instructions = description_command.instructions.accept(self, nil)
    object_id = description_command.object_ID.accept(self, nil) #for the moment unused
    @file.write(instructions+"\n")
  end

  ### tout ça inutile pour l'instant à remove
  def visit_instructions instructions, arg
    if instructions.value.length == 0
      raise 'Instruction is empty'
    else
      return instructions.value
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

  #--------------------------------------------------------------------------------------------------------------------

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
    case unit
    when 'sec'
      temp_time = temp_time*1000
    end
    @current_time = temp_time
    return nil
  end

  def visit_call_command command, arg
    object_id = command.object_id.accept(self, nil)
    action_id = command.action_id.accept(self, nil)
    number_actual_parameter = command.actual_parameter.accept(self, nil)
    number_formal_parameters = @symbol_table.lookup(object_id, action_id)
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

  #--------------------------------------------------------------------------------------------------------------------

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
    return nil
  end

end