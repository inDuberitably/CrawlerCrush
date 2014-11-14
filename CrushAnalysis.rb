class WordObj
	@@indices = Array.new
	attr_accessor :word, :occurences, :indices
	def initialize(word, occurences, indices) #
		@word = word
		@word_s = "#{word}"
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
	
	def to_s
		"#{@word_s} -> [#{@child.map(&:word).join(' ')}]" 
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
	
	def add_edge(parent, child)
		@word_objs.fetch(parent).add_edge(@word_objs[child])
	end

	def [](name)
		"#{@word_objs[name].rep}" "#{@word_objs[name]}"
	end

	def print_graph()
		puts "#{@word_objs.inspect}"
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
			word_obj = WordObj.new("",0,[],nil)
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
				puts "here"
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
#CA.find_context("girl")
#CA.print_most_used_words
W0 = WordObj.new(:head, 1, [1,2,3])
W1 = WordObj.new(:headphones,  1, [1,2,3])
W2 = WordObj.new(:headshot,  1, [1,2,3])
WG = WordGraph.new
WG.add_node(W0)
WG.add_node(W1)
WG.add_node(W2)
WG.add_edge(:headphones, :head)
#WG.add_edge(:head, :headshot)
#WG.add_edge(:headshot, :headphones)

puts WG[:headphones]