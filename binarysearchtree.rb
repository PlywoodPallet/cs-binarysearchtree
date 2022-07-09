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


# I hate recursion. It's difficult to debug. I feel like this makes it hard to code incrementally. I feel pressured to write a working solution all in one go, which is not how I code. I like to slowly add snippets of code which I test along the way. 
class Tree
  attr_accessor :root
  
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
  # 3) Node to be deleted has two children. 
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

      # Node with two children: 
      # 1) Find the inorder predecessor in the right subtree (Find the node that is slightly bigger (go to right subtree, then get the left most subtree - not necessarily a leaf)). 
      # 2) Replace the value of the node with the next biggest node value.
      new_minimum_value = minimum_value(node.right_node)
      node.value = new_minimum_value

      # 3) Delete old position of the next biggest node value with another delete_recursive call, which takes it's possible children into account
      node.right_node = delete_recursive(node.right_node, new_minimum_value)
    end

    return node
  end

  # Find the smallest value in a tree. Helper function for #delete_recursive
  # Possible bug: finding min value on the root of a tree doesn't return the correct result, but performing method on left and right subtrees works. The latter is all that is needed for #delete_recursive to work on nodes with two children
  def minimum_value(node)
    min_value = node.value

    unless (node.left_node == nil)
        min_value = node.left_node.value
        node = node.left_node
    end
    
    min_value
  end

  def find(value)
    find_recursive(@root, value)
  end

  # If value exists in a node, return the node. Else return nil
  def find_recursive(node, value)
    # base case: current node is empty, which means we reached a leaf. Return nil
    if (node == nil) 
      return nil
    end

    # base case: value has been found, return the node
    if (node.value == value)
      return node
    end

    # recursive case: judge current node value (start with root). Go left if query value is less than the current value. Go right if the query value is more than the current value
    # if the value exists, return nil and terminate the method
    if (value < node.value)
      find_recursive(node.left_node, value)
    elsif (value > node.value)
      find_recursive(node.right_node, value)
    end
  end

  # traverse the tree in breadth-first level order and yield each node to the provided block 
  # breath-first traversal: use a queue (first in first out). Visit a node, enqueue its children. Shift the first node in the queue, grab the value until the queue is empty. 
  def level_order

    # initialize the queue and push the root into it
    node_queue = []
    node_queue.push(@root) 

    until (node_queue.length == 0)
      current_node = node_queue.shift
      yield (current_node.value)

      unless (current_node.left_node.nil?)
        node_queue.push(current_node.left_node) 
      end
      
      unless (current_node.right_node.nil?)
        node_queue.push(current_node.right_node) 
      end
    end

  end

end

array = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]

a_tree = Tree.new(array)

a_tree.pretty_print

a_tree.level_order {|n| puts n}
