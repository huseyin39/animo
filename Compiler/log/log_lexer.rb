module Log_lexer
  class Lexer
    def initialize
      super
      keyword 'start'
      keyword 'end'
      keyword 'nsS'
      keyword 'µS'
      keyword 'ms'
      keyword 's'

    end
  end
end

a = []
a << [:skip, 4]

