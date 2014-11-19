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
		if !@child.nil?
			return false
		else
			return true
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

	def [](name)
		"#{@word_objs[name].rep}" "#{@word_objs[name]}"
	end
end
