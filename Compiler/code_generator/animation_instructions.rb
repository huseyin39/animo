require_relative 'useful_methods'

module AnimationInstructions
  class ObjectInitialization
    attr_accessor :identifier, :path, :window_width, :window_height

    def initialize identifier, path, window_width = 1000, window_height = 600
      @identifier = identifier
      @path = path
      @window_width = window_width
      @window_height = window_height
    end

    def write
      raise 'abstract method'
    end
  end

  class MoveInitialization < ObjectInitialization
    def initialize file, identifier, path, window_width = 1000, window_height = 600
      super(identifier, path, window_width, window_height)
      write(file)
    end

    def write file
      width, height = resize_svg(@path)
      string = "var #{identifier} = new Move('#{@path}', #{@window_width}, #{@window_height}, #{width}, #{height});\n"
      file.write(string)
    end
  end

  class Instruction
    attr_accessor :duration, :identifier, :parameters

    def initialize duration, identifier, *parameters
      @duration = duration
      @identifier = identifier
      @parameters = parameters
    end

    def write file
      raise 'abstract method'
    end
  end


  class MoveInstruction < Instruction
    def initialize file, duration, identifier, first = false, *parameters
      super(duration, identifier, parameters)
      if (first == true)
        write_first_line(file)
      else
        write(file)
      end
    end

    def write file
      distance, angle= @parameters[0]
      string = "#{@identifier}.moveToAndRotation(#{distance}, #{angle}, #{duration});\n"
      file.write(string)
    end

    def write_first_line file
      string = "\n#{@identifier}.rotate(#{@parameters[0][0]});\n"
      file.write(string)
    end
  end
end