class WordObj
	@@indices = Array.new
	@@child = WordObj.new
	attr_accessor :word, :indices, :occurences, :child
	attr_writer :word,:indices, :occurences, :child
	def initialize(word, occurences, indices, child)
		@word = word
		@occurences = occurences
		@indices = indices
		@child = child
	end
	def self.all_instances
		@indices << self
	end

=begin
	link roots takes two nodes and creates the "root". 
	For instance, if the words were "head" and "headphones" 
	the root would be head, returning all the instances of 
	head in "headphones". 		
=end
	def link(root_word)
		if self.word.downcase.include? root_word.word.downcase or root_word.word.downcase.include? self.word.downcase
			sum_of_occurences = self.occurences + root_word.occurences
			word_root = ""
			linked_indices = []
			linked_indices= self.indices  | root_word.indices
			if self.word.length < root_word.word.length
				word_root = self.word
				return WordObj.new(word_root, sum_of_occurences, linked_indices, root_word)
			else
				word_root = root_word.word
				return WordObj.new(word_root, sum_of_occurences, linked_indices, self)
			end
		else
			raise "Unable to link WordObjects"
		end
	end
	def link_roots(root_word)
		node =	link(root_word)
		puts node.inspect
		if !node.has_children()
			puts "here"
			node =	node.child.link(node)
			return node
		else
			return link_roots(node)
		end
	end
=begin
	Finds all links between a given WordObj 
	and produces a string representation of
	the traversal
=end	
	def toString()
		rep = ""
		node = self
		rep << "Word:#{node.word}\nOccurences:#{node.occurences}\nIndices:#{node.indices}\n"
		while !node.has_children()
			node = node.child
			rep << "Word:#{node.word}\nOccurences:#{node.occurences}\nIndices:#{node.indices}\n"
		end
		return rep
	end
	def has_children()
		begin
			if self.child.nil?
				return true
			else
				return false
			end
		rescue NoMethodError => e
			return true
		end
	end
end
class CrushAnalysis
	def initialize (tweets,tweets_arr, stopwords)
		@original_target = define_target(tweets)
		@stop_word_dictionary = File.open(stopwords).read
		@stop_time_dictionary = File.open(stopwords).read
		@stop_time_arr = File.open(stopwords).read.split("\n")
		@stop_words_arr = File.open(stopwords).read.split("\n")
		@original_target_arr =define_target_arr(tweets_arr)
		@target_text_hash = create_hash(@original_target)
		@target_words_obj_arr = create_word_obj()
	end

	attr_accessor :target_text_hash, :target_words_obj_arr, :original_target_arr
	def define_target(tweets)
		@original_target = File.open(tweets).read
		return @original_target
	end

	def define_target_arr(tweets)
		i = 0
		arr = []
		IO.foreach tweets do |tweet|
			arr[i] = tweet
			i+= 1
		end
		return arr
	end
	def create_hash(target)
		target_text_hash = {}
		tweets = target

		tweets.each_line do |tweet|
			txt = tweet
			txt.downcase!
			words = txt.scan(/[(\W+'\w+)]([^ -?".!,()]*)/).flatten.select{|w| w.length > 2}
			words.each do |word|
				if !@stop_words_arr.include?(word) or !@stop_time_arr.include?(word)
					target_text_hash[word] ||= 0
					target_text_hash[word] += 1
				end
			end
		end

		target_text_hash=Hash[target_text_hash.sort_by{|k,v|v}]
		return target_text_hash
	end

	def print_indices(tweet_indicies)
		i = 0
		while(i < tweet_indicies.indices.length)
			x = tweet_indicies.indices[i]
			puts " Tweet #{x}: #{original_target_arr[x]}"
			i +=1
		end
	end
	def create_word_obj()
		index_hash =@target_text_hash
		words_arr = []
		index_hash.each do |key, value|
			word_obj = WordObj.new
			i = 0 # index for array
			x = 0
			temp_arr = []
			word_obj.word = key
			word_obj.occurences = value
			@original_target_arr.each do |tweet|
				tweet.gsub!(/["]/, "")
				tweet.downcase!
				tweet_by_words = tweet.split(' ')
				if tweet_by_words.include? key
					temp_arr[x] = i
					x += 1
				end
				i += 1
				word_obj.indices = temp_arr.compact
			end


			words_arr << word_obj
		end
		return words_arr
	end
	def find_context(target)
		if @original_target.downcase.include? (target.downcase) or @original_target.upcase.include? (target.upcase)
			context = target.downcase
			arr 	= context.scan(/\w+/).flatten
			i = 0
			result = 0
			while(i < arr.length)
				if  @target_text_hash.has_key?(arr[i])
					result += 1
				end
				i+=1
			end
			if result == arr.length
				puts "#{target} exists!"
				i = 0
				while (i < @target_words_obj_arr.length)
					if target_words_obj_arr[i].word == context
						puts target_words_obj_arr[i].toString
						print_indices(target_words_obj_arr[i])
					end
					i+=1
				end
			end
		else
			puts "#{target} does not exist."
		end
	end
	def print_most_used_words()
		@target_text_hash.each{|key, value| puts "#{key} : #{value}"  }
	end
	def print_tweets()
		puts @original_target
	end
	private :print_indices, :define_target, :define_target_arr, :create_word_obj
end

#CA = CrushAnalysis.new("WRIGHT_CRUSHES_asText.txt","WRIGHT_CRUSHES_asText.txt", "StopWords.txt")
#CA.find_context("head")
#CA.print_most_used_words
W0 = WordObj.new("head",1, [1,2,3],nil)
W1 = WordObj.new("headphones",3,[1,33,3,5],nil)
W2 = WordObj.new("headshot",2,[7],W1)
W3 =W0.link_roots(W2)
puts W3.toString