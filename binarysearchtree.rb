class Node

  attr_accessor :value, :left_node, :right_node

  def initialize
    @value = nil
    @left_node = nil
    @right_node = nil
  end

  def to_s
    output = "value: #{value} left node: #{left_node} right node: #{right_node}"
  end
end

class Tree
  def initialize(array)
    #sort array and remove duplicates 
    @root = build_tree(array.sort.uniq)

  end

  # build a balanced search tree with array as input
  def build_tree(array)

  end


end
puts a_node
