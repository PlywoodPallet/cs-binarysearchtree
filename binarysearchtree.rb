class Node
  attr_accessor :value, :left_node, :right_node

  # include Comparable

  def initialize (value = nil)
    @value = value
    @left_node = nil
    @right_node = nil
  end

  # # Comparable
  # def <=>(other)
  #   @value <=> other.value
  # end

  def to_s
    output = "[value: #{value} left node: #{left_node} right node: #{right_node}]"
  end
end


# I hate recursion. It's difficult to debug
class Tree
  def initialize(array)
    #sort array and remove duplicates 
    array = array.sort.uniq

    @root = build_tree(array, 0, array.length-1)
    
    # p "Sorted Array: #{array.sort.uniq}"
    # p mid = (0+array.length-1)/2
    # p "Mid value: #{array[mid]}"

  end

  # build a balanced search tree with array as input
  # assumption: array is sorted and contains no duplicates

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

  # for visualizing trees. copy/pasted code from Odin project description
  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right_node, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_node
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left_node, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_node
  end


  def insert(value)
    @root = insert_recursive(@root, value)
  end

  def insert_recursive(node, value)
    
    # base case: current node is empty, which means we reached a leaf. Return a new Node object with value
    # also inserts a new node into an empty tree
    if (node == nil) 
      node = Node.new(value)
      return node
    end

    # recursive case: judge current node value (start with root). Go left if inserted value is less than the current value. Go right if the inserted value is more than the current value
    # if the value exists, return nil and terminate the method
    if (value < node.value)
      node.left_node = insert_recursive(node.left_node, value)
    elsif (value > node.value)
      node.right_node = insert_recursive(node.right_node, value)
    end

    return node
  end

  def delete(value)
    @root = delete_recursive(@root, value)
  end

  # can only delete leaves at the moment
  # Need to cover three cases
  # 1) Node to be deleted is a leaf
  # 2) Node to be deleted only had one child. Copy the child to the node and delete the child
  # 3) Node to be deleted has two children. Find the node that is slightly bigger (go to right subtree, then get the left most subtree - not necessarily a leaf)
  def delete_recursive(node, value)
  
    # base case: node is null, meaning a leaf has been reached. Terminate recursion
    if (node == nil) 
      return node
    end

    # recursive case: go left or right
    if (value < node.value)
      node.left_node = delete_recursive(node.left_node, value)
    elsif (value > node.value)
      node.right_node = delete_recursive(node.right_node, value)
    end

    # base case: node has been found with correct value
    if (node.value == value)
        
      # node with only one child will be replaced with non-nil child
      # node with no children will be replaced with nil (both left_node and right_node will be nil)
      if (node.left_node == nil)
          return node.right_node
        elsif (node.right_node == nil)
          return node.left_node
      end
    end

    return node
  end

end

array = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]

a_tree = Tree.new(array)

a_tree.pretty_print

a_tree.delete(3)

a_tree.pretty_print
