class WordObj
  @@indices = Array.new
  attr_accessor :word, :occurences, :indices
  def initialize(word, occurences, indices) #
    @word = word
    @indices = indices
    @occurences = occurences
    @child = []
  end

  def self.all_instances
    @indices << self
  end

  def add_edge(child)
    @child << child
  end

  def remove_edge(node)
    @child.delete(node)
    if @child.include? node
      return false
    else
      return true
    end
  end

  def has_children()
    if @child.empty?
      return false
    else
      return true
    end
  end
  def unique()
    if @child.include? self and @child.length == 1
      return true
    else
      return false
    end
  end

  def to_s
    "#{@word.to_s} -> [#{@child.map(&:word).join(' ')}]"
  end

  def rep
    return "Word:#{self.word}\nOccurences:#{self.occurences}\nIndices:#{self.indices}\n"

  end
end

class WordGraph
  def initialize
    @word_objs = {}
  end

  def has_neighbors(homer)
    return self.recover_node(homer).has_children
  end
  def has_node(node)
    return self.recover_node(node).nil?
  end
  
  def add_node(node)
    @word_objs[node.word] = node
  end

  def remove_node(node)
    @word_objs[node.word] = nil
    @word_objs.delete_if {|k,v| v.nil?}
  end

  def remove_edge(parent, child)
    target=@word_objs.fetch(parent.word)
    self.remove_node(parent)
    target.remove_edge(child)
    self.add_node(target)
  end

  def add_edge(parent, child)
    @word_objs.fetch(parent).add_edge(@word_objs[child])
  end

  def recover_node(parent)
    begin
      return @word_objs.fetch(parent)
    rescue Exception => e
      puts e
    end
  end

  def [](name)
    begin
      "#{@word_objs[name].rep}" "#{@word_objs[name]}"
    rescue NoMethodError => e
      puts "#{name} does not currently exist in the Word Graph"
    end
  end
  
  def nodes_with_neighbors()
    node_bool = []
    @word_objs.each do |w|
      i = 0
      node = self.recover_node(w[i])
      if node.has_children
        puts node
        node_bool.push(node)
      end
      i +=1
    end
    return node_bool
  end

  def nodes_without_neighbors
    node_bool = []
    @word_objs.each do |w|
      i = 0
      node = self.recover_node(w[i])
      if !node.has_children
        node_bool.push(node)
      end
      i +=1
    end
    return node_bool
  end
  def nodes_reflexive
    node_bool = []
    @word_objs.each do |w|
      i = 0
      node = self.recover_node(w[i])
      if node.unique
        node_bool.push(node)
      end
      i +=1
    end
    return node_bool
  end

end
=begin
WG = WordGraph.new
W0 = WordObj.new("yolo", 1, [3])
W1 = WordObj.new("swag", 1, [3])
W2 = WordObj.new("skrilla", 1, [3])
W3 = WordObj.new("monkey", 1, [3])
puts WG.has_node "skrilla"
=end