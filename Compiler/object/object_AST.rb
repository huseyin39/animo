require_relative '../AST'



module ObjectAST

  class Program < (AbstractSyntaxTree::AST)
    attr_accessor :declaration

    def initialize declaration
      @declaration = declaration
    end

    def visit visitor, arg=nil
      return visitor.visitProgram(self, arg)
    end
  end

  class ProgramObject < (AbstractSyntaxTree::AST)
    attr_accessor :declarations

    def initialize declarations
      @declarations = declarations
    end

    def visit visitor, arg=nil
      return visitor.visitProgramObject(self, arg)
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
      return visitor.visitSingleDeclaration(self, arg)
    end
  end

  class SequentialDeclaration < Declaration
    attr_accessor :declaration1, :declaration2

    def initialize declaration1, declaration2
      @declaration1 = declaration1
      @declaration2 = declaration2
    end

    def visit visitor, arg=nil
      return visitor.visitSequentialDeclaration(self, arg)
    end
  end


  class Filename < (AbstractSyntaxTree::Terminal)
    def initialize value
      super(value)
    end

    def visit visitor, arg=nil
      return visitor.visitFilename(self, arg)
    end
  end

  class Type < (AbstractSyntaxTree::Terminal)
    def initialize value
      super(value)
    end

    def visit visitor, arg=nil
      return visitor.visitType(self, arg)
    end
  end
end