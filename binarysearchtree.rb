class Node
  attr_accessor :value, :left_node, :right_node

  include Comparable

  def <=>(other)
    @value <=> other.value
  end

  def initialize (value = nil)
    @value = value
    @left_node = nil
    @right_node = nil
  end

  def to_s
    output = "[value: #{value} left node: #{left_node} right node: #{right_node}]"
  end
end

class Tree
  def initialize(array)
    #sort array and remove duplicates 
    @root = build_tree(array.sort.uniq, 0, array.length-1)

  end

  # build a balanced search tree with array as input
  # assumption: array already has duplicates removed

  # Recursion:
  # calculate mid of left subarray and make it root of left subtree of original root
  # calculate mid of right subarray and make it root of left subtree of original root
  def build_tree(array, array_start, array_end)

    if (array_start>array_end)
      return nil
    end

    mid = (array_start+array_end)/2

    root = Node.new(array[mid])

    root.left_node = build_tree(array, array_start, mid-1)
    root.right_node = build_tree(array, mid+1, array_end)

    root
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right_node, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_node
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left_node, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_node
  end


end

array = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]

a_tree = Tree.new(array)

a_tree.pretty_print
