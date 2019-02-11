class SymbolTable
  attr_accessor :table

  def initialize
    @table = Hash.new
  end

  def insert id, attr
    if (@table.has_key?(id))
      raise '#{id.to_s} has already been declared'
    else
      @table[id] = attr
    end
  end

  def retrieve id
    return @table[id]
  end
end