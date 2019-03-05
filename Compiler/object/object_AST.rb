require_relative '../AST'



module ObjectAST

  class ProgramObject < (AbstractSyntaxTree::AST)
    attr_accessor :declaration_block

    def initialize declaration_block, command_block
      @declaration_block = declaration_block
      @command_block = command_block
    end

    def accept visitor, arg=nil
      return visitor.visit_program_object(self, arg)
    end
  end

  class DeclarationBlock < (AbstractSyntaxTree::AST)
    attr_accessor :declarations
    def initialize declarations
      @declarations = declarations
    end

    def accept visitor, arg=nil
      return visitor.visit_declaration_block(self, arg)
    end
  end

  class AssignmentBlock < (AbstractSyntaxTree::AST)
    attr_accessor :assignments
    def initialize assignments
      @assignments = assignments
    end

    def accept visitor, arg=nil
      return visitor.visit_assignment_block(self, arg)
    end
  end

  class Declaration < (AbstractSyntaxTree::AST)
  end

  class FunctionDeclaration < Declaration
    attr_accessor :identifier, :formal_parameters_sequence, :string

    def initialize identifier, formal_parameters_sequence, string
      @identifier = identifier
      @formal_parameters_sequence = formal_parameters_sequence
      @string = string
    end

    def accept visitor, arg=nil
      return visitor.visit_function_declaration(self, arg)
    end
  end

  class ConstDeclaration < Declaration
    attr_accessor :identifier, :formal_parameters_sequence, :string

    def initialize identifier, formal_parameters_sequence, string
      @identifier = identifier
      @formal_parameters_sequence = formal_parameters_sequence
      @string = string
    end

    def accept visitor, arg=nil
      return visitor.visit_const_declaration(self, arg)
    end
  end

  class SequentialDeclaration < Declaration
    attr_accessor :declaration1, :declaration2

    def initialize declaration1, declaration2
      @declaration1 = declaration1
      @declaration2 = declaration2
    end

    def accept visitor, arg=nil
      return visitor.visit_sequential_declaration(self, arg)
    end
  end

  class Assignment < (AbstractSyntaxTree::AST)
    attr_accessor :identifier_object, :identifier_operator, :actual_parameters_sequence

    def initialize identifier_object, identifier_operator, actual_parameters_sequence
      @identifier_object = identifier_object
      @identifier_operator = identifier_operator
      @actual_parameters_sequence = actual_parameters_sequence
    end

    def accept visitor, arg=nil
      return visitor.visit_assignment(self, arg)
    end
  end

  class SequentialDeclaration < Declaration
    attr_accessor :declaration1, :declaration2

    def initialize declaration1, declaration2
      @declaration1 = declaration1
      @declaration2 = declaration2
    end

    def accept visitor, arg=nil
      return visitor.visit_sequential_declaration(self, arg)
    end
  end

  class String < (AbstractSyntaxTree::Terminal)
    def initialize value
      super(value)
    end

    def accept visitor, arg=nil
      return visitor.visit_string(self, arg)
    end
  end

  class Type < (AbstractSyntaxTree::Terminal)
    def initialize value
      super(value)
    end

    def accept visitor, arg=nil
      return visitor.visit_type(self, arg)
    end
  end
end