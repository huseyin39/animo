class SymbolTable
  attr_accessor :table

  def initialize
    @table = Hash.new
  end

  def to_s
    return @table
  end

  #symbol_table = {object_id : {action_id1 : [num_FPS, [parameter1, parameter2...],  expression], action_id2...}
  #attr = {action_id: [num_FPS, [parameter1, parameter2...], expression]}
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

  def lookup id, action_id
    if @table[id].nil?
      return nil
    else
      return @table[id][action_id][0]
    end
  end
end