require_relative 'animation_instructions'

class CodeGenerator
  def initialize symbol_table
    @file = nil
    @symbol_table = symbol_table
    @current_time = 0
    @timestamps = Hash.new #{object_id: [t0, .... t-1, t]}
  end

  def generate ast, filename
    begin
      path = File.join(File.dirname(__FILE__ ), "../res/" + filename + ".animo")
      @file = File.new(path, 'w+')
      ast.accept(self, nil)
    ensure
      @file.close unless @file.nil?
    end
  end

  def visit_program program, arg
    program.program_object.accept(self, nil)
    program.program_log.accept(self, nil)
    return nil
  end

  # -------------------------------------------------------------------------------------------------------------------
  # Objects visit
  # -------------------------------------------------------------------------------------------------------------------

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
    AnimationInstructions::ObjectDescription.new(object_id, @file).write(instructions)
  end

  def visit_instructions instructions, arg
    if instructions.value.length == 0
      raise 'Instruction is empty'
    else
      return instructions.value
    end
  end

  # -------------------------------------------------------------------------------------------------------------------
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
    @current_time = temp_time
  end

  def visit_call_command command, arg
    object_id = command.object_id.accept(self, nil)
    action_id = command.action_id.accept(self, nil)
    actual_parameters = command.actual_parameter.accept(self, nil)
    animation_information = @symbol_table.lookup(object_id, action_id)
    insert_timestamp(object_id)
    if !(animation_information.nil?)
      AnimationInstructions::Animation.new(object_id, @file).write(animation_information, actual_parameters)
    end
  end

  def visit_actual_parameter actual_parameter, arg
    parameters_id = actual_parameter.parameters.accept(self, nil)
  end

  def visit_proper_actual_parameter proper_actual_parameter, arg
    parameter =  proper_actual_parameter.parameter.accept(self, nil)
    return [parameter]
  end

  def visit_proper_actual_parameter_sequence proper_actual_parameter_sequence, arg
    parameters = []
    param = proper_actual_parameter_sequence.parameter1.accept(self, nil)
    parameters.push(*param)
    param = proper_actual_parameter_sequence.parameter2.accept(self, nil)
    parameters.push(*param)
    return parameters
  end

  def visit_parameter parameter, arg
    return parameter.parameter_ast.accept(self, nil)
  end

  # -------------------------------------------------------------------------------------------------------------------
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

  #Method to insert a timestamp for a give object_id
  def insert_timestamp object_id
    if @timestamps[object_id].nil?
      @timestamps[object_id] = [@current_time]
    else
      @timestamps[object_id] << @current_time
    end
  end

end