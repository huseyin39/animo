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
      return visitor.visit_body(self, arg)
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
      return visitor.visit_single_line(self, arg)
    end
  end


  class SequentialLine < Line
    attr_accessor :line1, :line2

    def initialize line1, line2
      @line1 = line1
      @line2 = line2
    end

    def visit visitor, arg=nil
      return visitor.visit_sequential_line(self, arg)
    end
  end



  class Timestamp < (AbstractSyntaxTree::AST)
    attr_accessor :integer, :unit

    def initialize integer, unit = 'sec'
      @integer= integer
      @unit = unit
    end

    def visit visitor, arg=nil
      return visitor.visit_timestamp(self, arg)
    end
  end

  class Description < (AbstractSyntaxTree::AST)
    attr_accessor :identifier, :expression

    def initialize identifier, expression
      @identifier = identifier
      @expression = expression
    end

    def visit visitor, arg=nil
      return visitor.visit_description(self, arg)
    end
  end

  class Expression < (AbstractSyntaxTree::AST)
  end

  class UnaryExpression < Expression
    attr_accessor :unary_action, :arg

    def initialize unary_action, arg
      @unary_action = unary_action
      @arg = arg
    end

    def visit visitor, arg=nil
      return visitor.visit_unary_expression(self, arg)
    end
  end

  class BinaryExpression < Expression
    attr_accessor :binary_action, :arg1, :arg2

    def initialize unary_action, arg1, arg2
      @unary_action = unary_action
      @arg1 = arg1
      @arg2 = arg2
    end

    def visit visitor, arg=nil
      return visitor.visit_binary_expression(self, arg)
    end

  end

  class Parameter < (AbstractSyntaxTree::AST) #unused
  end

  class SingleParameter < Parameter
    attr_accessor :parameter_value

    def initialize parameter_value
      @parameter_value = parameter_value
    end

    def visit visitor, arg=nil
      return visitor.visit_single_parameter(self, arg)
    end
  end

  class SequentialParameter < Parameter
    attr_accessor :parameter1, :parameter2

    def initialize parameter1, parameter2
      @parameter1 = parameter1
      @parameter2 = parameter2
    end

    def visit visitor, arg=nil
      return visitor.visit_sequential_parameter(self, arg)
    end
  end

  class ParameterValue < (AbstractSyntaxTree::Terminal)
    def initialize value
      super(value)
    end

    def visit visitor, arg=nil
      return visitor.visit_parameter_value(self, arg)
    end
  end

  class Integer < (AbstractSyntaxTree::Terminal)
    def initialize value
      super(value)
    end

    def visit visitor, arg=nil
      return visitor.visit_integer(self, arg)
    end

    def == object
      if (object.nil? && object.instance_of?(Integer))
        return true
      else
        return false
      end
    end

    def to_s
      'Integer'
    end
  end

  class Unit < (AbstractSyntaxTree::Terminal)
    def initialize value
      super(value)
    end

    def visit visitor, arg=nil
      return visitor.visit_unit(self, arg)
    end
  end


  class Action < (AbstractSyntaxTree::Terminal) #unused
    attr_accessor :declaration

    def initialize value
      super(value)
      @declaration = nil
    end

    def visit visitor, arg=nil
      return visitor.visit_action(self, arg)
    end
  end

  class UnaryAction < (AbstractSyntaxTree::Terminal)
    attr_accessor :type

    def initialize value, type
      super(value)
      @type = type
    end

    def visit visitor, arg=nil
      return visitor.visit_unary_action(self, arg)
    end
  end

  class BinaryAction < (AbstractSyntaxTree::Terminal)
    attr_accessor :type

    def initialize value, type
      super(value)
      @type = type
    end

    def visit visitor, arg=nil
      return visitor.visit_binary_action(self, arg)
    end
  end
end