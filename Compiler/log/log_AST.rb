require_relative '../object/object_AST'
require_relative '../AST'


module LogAST

  class ProgramLog < (AbstractSyntaxTree::AST)
    attr_accessor :body

    def initialize body
      @body = body
    end

    def visit visitor, arg=nil
      return visitor.visitProgramLog(self, arg)
    end
  end



  class Body < (AbstractSyntaxTree::AST)
    attr_accessor :lines

    def initialize lines
      @lines = lines
    end

    def visit visitor, arg=nil
      return visitor.visitBody(self, arg)
    end
  end



  class Line < (AbstractSyntaxTree::AST)
  end

  class SingleLine < Line
    attr_accessor :timestamp,:description

    def initialize timestamp, description
      @timestamp = timestamp
      @description = description
    end

    def visit visitor, arg=nil
      return visitor.visitSingleLine(self, arg)
    end
  end


  class SequentialLine < Line
    attr_accessor :line1, :line2

    def initialize line1, line2
      @line1 = line1
      @line2 = line2
    end

    def visit visitor, arg=nil
      return visitor.visitSequentialLine(self, arg)
    end
  end



  class Timestamp < (AbstractSyntaxTree::AST)
    attr_accessor :integer, :unit

    def initialize integer, unit = 'sec'
      @integer= integer
      @unit = unit
    end

    def visit visitor, arg=nil
      return visitor.visitTimestamp(self, arg)
    end
  end

  class Description < (AbstractSyntaxTree::AST)
    attr_accessor :identifier, :action, :parameters

    def initialize identifier, action, parameters
      @identifier = identifier
      @action = action
      @parameters = parameters
    end

    def visit visitor, arg=nil
      return visitor.visitDescription(self, arg)
    end
  end

  class ActionExpression < (AbstractSyntaxTree::AST)
  end

  class UnaryAction < ActionExpression
    attr_accessor :action, :arg

    def initialize action, arg
      @action = action
      @arg = arg
    end

    def visit visitor, arg=nil
      return visitor.visitUnaryAction(self, arg)
    end
  end

  class BinaryAction < ActionExpression
    attr_accessor :action, :arg1, :arg2

    def initialize action, arg1, arg2
      @action = action
      @arg1 = arg1
      @arg2 = arg2
    end

    def visit visitor, arg=nil
      return visitor.visitBinaryAction(self, arg)
    end
  end

  class Parameter < (AbstractSyntaxTree::AST)
  end

  class SingleParameter < Parameter
    attr_accessor :parameter_value

    def initialize parameter_value
      @parameter_value = parameter_value
    end

    def visit visitor, arg=nil
      return visitor.visitSingleParameter(self, arg)
    end
  end

  class SequentialParameter < Parameter
    attr_accessor :parameter1, :parameter2

    def initialize parameter1, parameter2
      @parameter1 = parameter1
      @parameter2 = parameter2
    end

    def visit visitor, arg=nil
      return visitor.visitSequentialParameter(self, arg)
    end
  end



  class ParameterValue < (AbstractSyntaxTree::Terminal)
    def initialize value
      super(value)
    end

    def visit visitor, arg=nil
      return visitor.visitParameterValue(self, arg)
    end
  end

  class Integer < (AbstractSyntaxTree::Terminal)
    def initialize value
      super(value)
    end

    def visit visitor, arg=nil
      return visitor.visitInteger(self, arg)
    end
  end

  class Unit < (AbstractSyntaxTree::Terminal)
    def initialize value
      super(value)
    end

    def visit visitor, arg=nil
      return visitor.visitUnit(self, arg)
    end
  end


  class Action < (AbstractSyntaxTree::Terminal)
    attr_accessor :declaration

    def initialize value
      super(value)
      @declaration = nil
    end

    def visit visitor, arg=nil
      return visitor.visitAction(self, arg)
    end
  end
end