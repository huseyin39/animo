
class Token
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
    elsif (@kind == LOG_TOKEN_KINDS[:IDENTIFIER])
        (LOG_TOKEN_KINDS[:BEGIN]..LOG_TOKEN_KINDS[:SEC]).each do |i|
          if @value.eql?(VALUE[i])
            @kind = i
            break
          end
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

LOG_TOKEN_KINDS = {INTEGER: 0,
                   CHAR: 1,
                   STRING: 3,
                   IDENTIFIER: 4,
                   BEGIN: 5,
                   END: 6,
                   SEC: 7,
                   COLON: 8,
                   SEMICOLON: 9,
                   COMMA: 10,
                   LPARENTHESIS: 11,
                   RPARENTHESIS: 12,
                   EOF: 13}

VALUE = ['<integer>', '<unaryaction>', '<binaryaction>', '<parametervalue>', '<identifier>', 'begin', 'end', 'sec', ':', ';', ',', '(', ')']
