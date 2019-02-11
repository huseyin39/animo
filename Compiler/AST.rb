module AbstractSyntaxTree
  class AST
  end

  class Program < AST
    attr_accessor :program_log, :program_object

    def initialize program_log, program_object
      @program_log = program_log
      @program_object = program_object
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

    def visit visitor, arg=nil
      return visitor.visitIdentifier(self, arg)
    end
  end
end
