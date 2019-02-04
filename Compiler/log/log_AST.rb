module LogAST
  class AST
  end

  class Program < AST
    attr_accessor :body

    def initialize body
      @body = body
    end
  end



  class Body < AST
    attr_accessor :lines

    def initialize *lines
      @lines = lines
    end
  end



  class Line < AST
  end

  class SingleLine < Line
    attr_accessor :timestamp,:description

    def initialize timestamp, description
      @timestamp = timestamp
      @description = description
    end
  end


  class SequentialLine < Line
    attr_accessor :line1, :line2

    def initialize line1, line2
      @line1 = line1
      @line2 = line2
    end
  end



  class Timestamp < AST
    attr_accessor :integer, :unit

    def initialize integer, unit = 'sec'
      @integer= integer
      @unit = unit
    end
  end

  class Description < AST
    attr_accessor :parameters, :action, :identifier

    def initialize identifier, action, parameters
      @identifier = identifier
      @action = action
      @parameters = parameters
    end
  end


  class Parameter < AST
  end

  class SingleParameter < Parameter
    attr_accessor :parameter_value

    def initialize parameter_value
      @parameter_value = parameter_value
    end
  end

  class SequentialParameter < Parameter
    attr_accessor :parameter1, :parameter2

    def initialize parameter1, parameter2
      @parameter1 = parameter1
      @parameter2 = parameter2
    end
  end



  class Terminal < AST
    attr_accessor :value

    def initialize value
      @value = value
    end
  end


  class Identifier < Terminal
    def initialize value
      @value = super(value)
    end
  end


  class ParameterValue < Terminal
    def initialize value
      super(value)
    end
  end

  class Integer < Terminal
    def initialize value
      super(value)
    end
  end

  class Unit < Terminal
    def initialize value
      super(value)
    end
  end


  class Action < Terminal
      def initialize value
        super(value)
      end
  end
end