class Token
  attr_reader :kind, :value

  def initialize (kind, value)
    @kind = kind
    @value = value
    if (@kind == TOKEN_KINDS[:IDENTIFIER])
      if @value.eql?('move') #add here the rest
        @kind = 2
      else
        (TOKEN_KINDS[:BEGIN]..TOKEN_KINDS[:SEC]).each do |i|
          if @value.eql?(VALUE[i])
            @kind = i
            break
          end
        end
      end
    end
  end

  #To check the kind of the currentToken
  def is_a? kind #unused
    if @kind == kind
      return true
    else
      raise "Wrong type"
    end
  end
end

TOKEN_KINDS = {INTEGER: 0,
               UNARYACTION: 1,
               BINARYACTION: 2,
               PARAMETERVALUE: 3,
               IDENTIFIER: 4,
               BEGIN: 5,
               END: 6,
               SEC: 7,
               COLON: 8,
               SEMICOLON: 9,
               COMMA: 10,
               LPARENTHESIS: 11,
               RPARENTHESIS: 12}

VALUE = ['<integer>', '<unaryaction>', '<binaryaction>', '<parametervalue>', '<identifier>', 'begin', 'end', 'sec', ':', ';', ',', '(', ')']
