require './WordGraph'

class CrushAnalysis
	attr_accessor :target_text_hash, :target_words_obj_arr, :original_target_arr
	def initialize (tweets,tweets_arr, stopwords)
		@original_target = define_target(tweets)
		@stop_word_dictionary = File.open(stopwords).read
		@stop_time_dictionary = File.open(stopwords).read
		@stop_time_arr = File.open(stopwords).read.split("\n")
		@stop_words_arr = File.open(stopwords).read.split("\n")
		@original_target_arr =define_target_arr(tweets_arr)
		@target_text_hash = create_hash(@original_target)
		@target_words_obj_arr = create_word_obj()
		@word_adjacency_list = generate_graph()
	end

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

	def create_word_obj()
		index_hash =@target_text_hash
		words_arr = []
		index_hash.each do |key, value|
			word_obj = WordObj.new("",0,[])
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

	def generate_graph()
		i = 0
		word_graph = WordGraph.new
		word = WordObj.new("",0,[])
		while (i <@target_words_obj_arr.length)
			word = @target_words_obj_arr[i]
			@target_words_obj_arr.each do |w|
				if word.word.include? w.word
					word.add_edge(w)
				end
			end
			word_graph.add_node(word)
			i += 1
		end
		return word_graph
	end
	def [](key)
		puts @word_adjacency_list[key]
	end
	def print_most_used_words()
		@target_text_hash.each{|key, value| puts "#{key} : #{value}"  }
	end
	def print_unique_words()
		puts @word_adjacency_list.nodes_reflexive.length

	end
	def print_tweets()
		puts @original_target
	end
	def print_graph_neighbors()
		puts @word_adjacency_list.nodes_with_neighbors().length
	end
	def find_context(target_context)
		if (@original_target.include? target_context.downcase or @original_target.include? target_context.upcase)
			clue =	@word_adjacency_list.recover_node(target_context)
			self.print_indices(clue.word)
			puts "#{clue.rep}#{clue.to_s}\n"
		else
			puts "couldn't find #{target_context} :("
		end
	end

	def print_indices(key)
		word_obj = @word_adjacency_list.recover_node(key)
		i = 0
		tweets_arr = word_obj.indices
		while(i < tweets_arr.length)
			x = tweets_arr[i]
			puts " Tweet #{x}: #{original_target_arr[x]}"
			i +=1
		end
	end
	private  :define_target, :define_target_arr, :create_word_obj, :generate_graph
end

