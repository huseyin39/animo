class SymbolTable
  attr_accessor :table

  def initialize
    @table = Hash.new
  end

  def to_s
    return @table
  end

  #symbol_table = {id : {action_id1 : [num_FPS, expression], action_id2...}; attr = {action_id: [num_FPS, expression]}
  def insert id, attr
    key = attr.keys[0]
    value = attr[key]
    if (@table.has_key?(id))
      puts @table[id].class
      if (@table[id][key]).nil?
        @table[id][key] = value
      else
        raise "the object #{id} has already an animation called #{key}"
      end
    else
      @table[id] = {key => value}
    end
  end

  def retrieve id, action_id
    if @table[id].nil?
      return nil
    else
      return @table[id][action_id][0]
    end
  end
end