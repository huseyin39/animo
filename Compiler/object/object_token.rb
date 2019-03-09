class ObjectToken
  attr_reader :kind, :value

  def initialize (kind, value)
    @kind = kind
    @value = value
    if (@kind == OBJECT_TOKEN_KINDS[:IDENTIFIER])
      if @value.eql?('Animation')#add here the rest
        @kind = 1
      elsif @value.eql?('Description')
        @kind = 2
      end
    end
  end
end


OBJECT_TOKEN_KINDS = {IDENTIFIER: 0,
                      ANIMATION: 1,
                      DESCRIPTION: 2,
                      SEMICOLON: 3,
                      COMMA: 4,
                      LPARENTHESIS: 5,
                      RPARENTHESIS: 6,
                      INSTRUCTIONS: 7,
                      EOF: 8}
