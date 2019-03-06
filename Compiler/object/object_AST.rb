require_relative '../AST'



module ObjectAST

  class ProgramObject < (AbstractSyntaxTree::AST)
    attr_accessor :command

    def initialize  command
      @command = command
    end

    def accept visitor, arg=nil
      return visitor.visit_program_object(self, arg)
    end
  end

  class Command < (AbstractSyntaxTree::AST)
  end

  class AnimationCommand < Command
    attr_accessor :object_ID, :action_ID, :formal_parameters_sequence, :expression

    def initialize object_ID, action_ID, formal_parameters_sequence, expression
      @object_ID = object_ID
      @action_ID = action_ID
      @formal_parameters_sequence = formal_parameters_sequence
      @expression = expression
    end

    def accept visitor, arg=nil
      return visitor.visit_animation_command(self, arg)
    end
  end

  class DescriptionCommand < Command
    attr_accessor :object_ID, :expression

    def initialize object_ID, expression
      @object_ID = object_ID
      @expression = expression
    end

    def accept visitor, arg=nil
      return visitor.visit_description_command(self, arg)
    end
  end

  class SequentialCommand < Command
    attr_accessor :command1, :command2

    def initialize command1, command2
      @command1 = command1
      @command2 = command2
    end

    def accept visitor, arg=nil
      return visitor.visit_sequential_command(self, arg)
    end
  end


  class Expression < (AbstractSyntaxTree::Terminal)
    def initialize value
      super(value)
    end

    def accept visitor, arg=nil
      return visitor.visit_expression(self, arg)
    end
  end


  class FormalParameter < (AbstractSyntaxTree::AST)
    attr_accessor :parameters

    def initialize parameters
      @parameters = parameters
    end

    def accept visitor, arg=nil
      if @parameters.nil?
        return 0
      end
      return visitor.visit_formal_parameter(self, arg)
    end
  end

  class ProperFormalParameter < FormalParameter
    attr_accessor :parameter

    def initialize parameter
      @parameter = parameter
    end

    def accept visitor, arg=nil
      return visitor.visit_proper_formal_parameter(self, arg)
    end
  end

  class ProperFormalParameterSequence < FormalParameter
    attr_accessor :parameter1, :parameter2

    def initialize parameter1, parameter2
      @parameter1 = parameter1
      @parameter2 = parameter2
    end

    def accept visitor, arg=nil
      return visitor.visit_proper_formal_parameter_sequence(self, arg)
    end
  end

  # class Type < (AbstractSyntaxTree::Terminal)
  #   def initialize value
  #     super(value)
  #   end
  #
  #   def accept visitor, arg=nil
  #     return visitor.visit_type(self, arg)
  #   end
  # end
end