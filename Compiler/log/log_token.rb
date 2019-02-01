class Token
  attr_reader :kind, :value

  def initialize (kind, value)
    @kind = kind
    @value = value
  end

  #To check the kind of the currentToken
  def is_a? kind
    if @kind == kind
      return true
    else
      raise "Wrong type"
    end
  end
end

TOKEN_KINDS = {INTEGER: 2,
               ACTION: 3,
               PARAMETERVALUE: 3,
               IDENTIFIER: 4,
               BEGIN: 5,
               END: 6,
               SEC: 7,
               COLON: 8,
               SEMICOLON: 9,
               COMMA: 10,
               UNDERSCORE: 11,
               LPARENTHESIS: 12,
               RPARENTHESIS: 13}

puts !('lol'.eql?'la')
