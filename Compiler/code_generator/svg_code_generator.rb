require_relative '../log/log_AST'
require_relative 'useful_methods'
require_relative 'animation_instructions'

class SvgCodeGenerator
  def initialize types, filename
    @types = types #need or not ?
    @filename = filename
    @file = nil
    @window_width = 1000
    @window_height = 600
    @information = Hash.new #[type, duration, coord, current_time, angle] duration = [t-1, t]; coord = [x-1, y-1, x, y]
  end

  def generate ast
    begin
      path = File.join(File.dirname(__FILE__ ), "../res/" + @filename + ".js")
      @file = File.new(path, 'w+')
      # if (!@types['move'].nil?)
      #   @file.write("import {Move} from \'./move.js\';\n\n")
      # end
      @file.write("var draw = SVG('drawing').size(#{@window_width}, #{@window_height});\n\n")
      ast.visit(self, nil)
      @information.each do |id, info|
        if (info[0].eql?('move'))
          distance = compute_distance(info[2])
          AnimationInstructions::MoveInstruction.new(@file, info[1][1], id, false, distance,0)
        end
      end
      AnimationInstructions::HTMLFileMove.new(@filename)
    ensure
      @file.close unless @file.nil?
    end
  end


  def visit_program program, arg
    program.program_object.visit(self, nil)
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
    single_line.description.visit(self, single_line)
    return nil
  end

  def visit_sequential_line sequential_line, arg
    sequential_line.line1.visit(self, nil)
    sequential_line.line2.visit(self, nil)
    return nil
  end

  def visit_timestamp timestamp, arg
    temp_time = timestamp.integer.visit(self, nil).to_i
    unit = timestamp.unit.visit(self, nil)
    case unit
    when 'sec'
      temp_time = temp_time*1000
    end

    @information[arg][1][0] = @information[arg][1][1]
    @information[arg][1][1] = temp_time - @information[arg][3]
    @information[arg][3] = temp_time
  end

  def visit_integer integer, arg
    return integer.value
  end

  def visit_unit unit, arg
    return unit.value
  end

  def visit_description description, arg #arg = single_line
    id = description.identifier.visit(self, nil)
    arg.timestamp.visit(self, id) #we visit here because each duration is related to an id
    description.expression.visit(self, id)
    return nil
  end

  def visit_unary_expression unary_expression, arg
    id = arg
    type_unary_expression = unary_expression.unary_action.visit(self, nil)
    type_arg = unary_expression.arg.visit(self, nil)
    case type_unary_expression
    when ''
    end
    return nil
  end

  def visit_binary_expression binary_expression, arg
    id = arg
    type_binary_expression = binary_expression.binary_action.visit(self, nil)
    arg1 = binary_expression.arg1.visit(self, nil)
    arg2 = binary_expression.arg2.visit(self, nil)
    case type_binary_expression
    when 'move'
      x, y, x1, y1 = @information[id][2].map{ |coord| if (!coord.nil?) then coord.to_f end}
      if (x.nil?)
        angle = compute_angle(x1, y1, arg1.to_f, arg2.to_f)
        if (!angle.nil?)
          @information[id][4] = angle
        end
        AnimationInstructions::MoveInstruction.new(@file, @information[id][1][0], id, true, @information[id][4])
      else
        distance, angle = compute_next_parameters(x, y, x1, y1, arg1.to_f, arg2.to_f)
        if (!angle.nil?)
          @information[id][4] = angle
        end
        AnimationInstructions::MoveInstruction.new(@file, @information[id][1][0], id, nil, distance, @information[id][4])
      end
      coord = [x1, y1, arg1.to_f, arg2.to_f]
      @information[id][2] = coord
    end
    return nil
  end

  def visit_unary_action unary_action, arg
    return unary_action.value
  end

  def visit_binary_action binary_action, arg
    return binary_action.value
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
    type = single_declaration.type.visit(self, nil)
    id = single_declaration.identifier.visit(self, nil)
    path = single_declaration.filename.visit(self, nil)
    case type
    when 'move'
      AnimationInstructions::MoveInitialization.new(@file, id, path, @window_width, @window_height)
      coord = [nil, nil, 0, 0]
      @information[id] = ['move', [nil, nil], coord, 0, 0]
    end
  end

  def visit_type type, arg
    return type.value
  end

  def visit_filename filename, arg
    return filename.value
  end

  def visit_identifier id, arg
    return id.value
  end
end