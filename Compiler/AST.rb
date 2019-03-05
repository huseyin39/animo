module AbstractSyntaxTree
  class AST
  end

  class Program < AST
    attr_accessor :program_log, :program_object

    def initialize program_object, program_log
      @program_object = program_object
      @program_log = program_log
    end

    def accept visitor, arg=nil
      return visitor.visit_program(self, arg)
    end
  end

  class FormalParameter < AST
  end

  class ProperFormalParameter < FormalParameter
    attr_accessor :parameter

    def initialize parameter
      @parameters = parameter
    end

    def accept visitor, arg=nil
      return visitor.visit_formal_parameter(self, arg)
    end
  end

  class ProperFormalParameterSequence < FormalParameter
    attr_accessor :parameter1, :parameter2

    def initialize parameter1, parameter2
      @parameter1 = parameter1
      @parameter2 = parameter2
    end

    def accept visitor, arg=nil
      return visitor.visit_formal_parameter(self, arg)
    end
  end

  class Terminal < AST
    attr_accessor :value

    def initialize value
      @value = value
    end
  end


  class Identifier < Terminal
    attr_accessor :declaration

    def initialize value
      super(value)
      @declaration = nil
    end

    def accept visitor, arg=nil
      return visitor.visit_identifier(self, arg)
    end
  end
end
