require_relative '../object/object_AST'
require_relative '../AST'


module LogAST

  class ProgramLog < (AbstractSyntaxTree::AST)
    attr_accessor :body

    def initialize body
      @body = body
    end

    def accept visitor, arg=nil
      return visitor.visit_program_log(self, arg)
    end
  end



  class Body < (AbstractSyntaxTree::AST)
    attr_accessor :lines

    def initialize lines
      @lines = lines
    end

    def accept visitor, arg=nil
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

    def accept visitor, arg=nil
      return visitor.visit_single_line(self, arg)
    end
  end


  class SequentialLine < Line
    attr_accessor :line1, :line2

    def initialize line1, line2
      @line1 = line1
      @line2 = line2
    end

    def accept visitor, arg=nil
      return visitor.visit_sequential_line(self, arg)
    end
  end



  class Timestamp < (AbstractSyntaxTree::AST)
    attr_accessor :integer, :unit

    def initialize integer, unit = 'sec'
      @integer= integer
      @unit = unit
    end

    def accept visitor, arg=nil
      return visitor.visit_timestamp(self, arg)
    end
  end

  class CallCommand < (AbstractSyntaxTree::AST)
    attr_accessor :object_id, :action_id, :actual_parameter

    def initialize object_id, action_id, actual_parameter
      @object_id = object_id
      @action_id = action_id
      @actual_parameter = actual_parameter
    end

    def accept visitor, arg=nil
      return visitor.visit_call_command(self, arg)
    end
  end


  class ActualParameter < (AbstractSyntaxTree::AST)
    attr_accessor :parameters

    def initialize parameters
      @parameters = parameters
    end

    def accept visitor, arg=nil
      if @parameters.nil?
        return 0
      end
      return visitor.visit_actual_parameter(self, arg)
    end
  end

  class ProperActualParameter < ActualParameter
    attr_accessor :parameter

    def initialize parameter
      @parameter = parameter
    end

    def accept visitor, arg=nil
      return visitor.visit_proper_actual_parameter(self, arg)
    end
  end

  class ProperActualParameterSequence < ActualParameter
    attr_accessor :parameter1, :parameter2

    def initialize parameter1, parameter2
      @parameter1 = parameter1
      @parameter2 = parameter2
    end

    def accept visitor, arg=nil
      return visitor.visit_proper_actual_parameter_sequence(self, arg)
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

  class IntegerLiteral < (AbstractSyntaxTree::Terminal)
    def initialize value
      super(value)
    end

    def accept visitor, arg=nil
      return visitor.visit_integer(self, arg)
    end

    # def == object
    #   if (!object.nil? && object.instance_of?(IntegerLiteral))
    #     return true
    #   else
    #     return false
    #   end
    # end

    def to_s
      'Integer'
    end
  end

  class Unit < (AbstractSyntaxTree::Terminal)
    def initialize value
      super(value)
    end

    def accept visitor, arg=nil
      return visitor.visit_unit(self, arg)
    end
  end
end