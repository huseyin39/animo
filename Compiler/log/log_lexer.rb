module Log_lexer
  class Lexer
    def initialize
      super
      keyword 'start'
      keyword 'end'
      keyword 'msec'
      keyword 'sec'

    end
  end
end

a = []
a << [:skip, 4]

