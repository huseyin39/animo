class ObjectToken
  attr_reader :kind, :value

  def initialize (kind, value)
    @kind = kind
    @value = value
    if (@kind == TOKEN_KINDS[:IDENTIFIER])
      if @value.eql?('dynamic') || @value.eql?('static') || @value.eql?('data')#add here the rest
        @kind = 1
      elsif @value[-4..-1].eql?('.svg')
      end
    end
  end
end


TOKEN_KINDS = {IDENTIFIER: 0,
               TYPE: 1,
               FILENAME: 2,
               EQUAL: 3,
               SEMICOLON: 4,
               COMMA: 5,
               DOUBLEQUOTE: 6}
