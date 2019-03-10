module AnimationInstructions
  class ObjectDescription
    def initialize identifier, file
      @identifier = identifier
      @file = file
    end

    def write instructions
      @file.write(instructions.strip+"\n")
    end
  end

  class Animation
    def initialize identifier, file
      @identifier = identifier
      @file = file
    end

    def write animation_information, actual_parameters, current_time
      formal_parameters_id, instructions = animation_information[1], animation_information[2]
      formal_to_actual = Hash.new
      formal_parameters_id.each_with_index { |parameter_id, index|
        formal_to_actual[parameter_id] = actual_parameters[index]
      }
      formal_parameters_id = formal_parameters_id.sort{|x, y| y.length <=> x.length}
      formal_parameters_id.each do |formal_parameter|
        actual_parameter = formal_to_actual[formal_parameter]
        instructions = instructions.gsub("#"+formal_parameter, actual_parameter)
      end
      instructions = instructions.gsub("#t", current_time.to_s)
      @file.write(instructions.strip!+"\n")
    end
  end
end