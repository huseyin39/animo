class ObjectToken
  attr_reader :kind, :value

  def initialize (kind, value)
    @kind = kind
    @value = value
    if (@kind == OBJECT_TOKEN_KINDS[:IDENTIFIER])
      if @value.eql?('move') || @value.eql?('data')#add here the rest || @value.eql?('static')
        @kind = 1
      elsif @value[-4..-1].eql?('.svg')
      end
    end
  end
end


OBJECT_TOKEN_KINDS = {IDENTIFIER: 0,
               TYPE: 1,
               FILENAME: 2,
               EQUAL: 3,
               SEMICOLON: 4,
               COMMA: 5,
               DOUBLEQUOTE: 6,
               EOF: 7}
