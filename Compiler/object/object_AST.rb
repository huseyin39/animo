require_relative '../AST'



module ObjectAST

  class ProgramObject < (AbstractSyntaxTree::AST)
    attr_accessor :declarations

    def initialize declarations
      @declarations = declarations
    end

    def visit visitor, arg=nil
      return visitor.visit_program_object(self, arg)
    end
  end

  class Declaration < (AbstractSyntaxTree::AST)
  end


  class SingleDeclaration < Declaration
    attr_accessor :identifier, :type, :filename

    def initialize identifier, type, filename
      @identifier = identifier
      @type = type
      @filename = filename
    end

    def visit visitor, arg=nil
      return visitor.visit_single_declaration(self, arg)
    end
  end

  class SequentialDeclaration < Declaration
    attr_accessor :declaration1, :declaration2

    def initialize declaration1, declaration2
      @declaration1 = declaration1
      @declaration2 = declaration2
    end

    def visit visitor, arg=nil
      return visitor.visit_sequential_declaration(self, arg)
    end
  end


  class Filename < (AbstractSyntaxTree::Terminal)
    def initialize value
      super(value)
    end

    def visit visitor, arg=nil
      return visitor.visit_filename(self, arg)
    end
  end

  class Type < (AbstractSyntaxTree::Terminal)
    def initialize value
      super(value)
    end

    def visit visitor, arg=nil
      return visitor.visit_type(self, arg)
    end
  end
end