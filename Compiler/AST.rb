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

  class Terminal < AST
    attr_accessor :value

    def initialize value
      @value = value
    end
  end


  class Identifier < Terminal
    attr_accessor :declaration

    def initialize value
      super(value.rstrip)
      @declaration = nil
    end

    def accept visitor, arg=nil
      return visitor.visit_identifier(self, arg)
    end
  end
end
