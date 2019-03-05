class ObjectToken
  attr_reader :kind, :value

  def initialize (kind, value)
    @kind = kind
    @value = value
    if (@kind == OBJECT_TOKEN_KINDS[:IDENTIFIER])
      if @value.eql?('animation')#add here the rest
        @kind = 1
      elsif @value.eql?('description')
        @kind = 2
      end
    end
  end
end


OBJECT_TOKEN_KINDS = {IDENTIFIER: 0,
                      ANIMATION: 1,
                      DESCRIPTION: 2,
                      EQUAL: 3,
                      SEMICOLON: 4,
                      COMMA: 5,
                      CHARACTER: 6,
                      LPARENTHESIS: 7,
                      RPARENTHESIS: 8,
                      LDOUBLEBRACKET: 9,
                      RDOUBLEBRACKET: 10,
                      EOF: 11}
