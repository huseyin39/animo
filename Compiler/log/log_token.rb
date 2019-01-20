class Token
  attr_accessor :kind, :value

  @INTLITERAL = 1
  @CHARLITERAL =
  @ACTION =
  @IDENTIFIER =   #Pour le nom du robot

  #Reserved words
  @BEGIN =            #begin
  @END =               #end
  @SEC =


  @COLON =             #:
  @SEMICOLON =         #;
  @LPARENTHESIS =
  @RPARENTHESIS =





  def initialize kind, value
    @kind = kind
    @value = value
  end


end

a = Token.new 4,5
puts
