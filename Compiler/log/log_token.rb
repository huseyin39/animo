class Token
  attr_reader :kind, :value

  def initialize (kind, value)
    @kind = kind
    @value = value
    if (@kind == TOKEN_KINDS[:IDENTIFIER])
      if @value.eql?('move') #add here the rest
        @kind = 1
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
               ACTION: 1,
               PARAMETERVALUE: 2,
               IDENTIFIER: 3,
               BEGIN: 4,
               END: 5,
               SEC: 6,
               COLON: 7,
               SEMICOLON: 8,
               COMMA: 9,
               LPARENTHESIS: 10,
               RPARENTHESIS: 11}

VALUE = ['<integer>', '<action>', '<parametervalue>', '<identifier>', 'begin', 'end', 'sec', ':', ';', ',', '(', ')']

