class WordObj
	@@indices = Array.new
	attr_accessor :word, :indices, :occurences
	attr_writer :word,:indices, :occurences
	def initalize()
		@word = ""
		@occurences = 0
		@indices << self
	end
	def self.all_instances
		@indices << self
	end
	def toString()
		rep="Word:#{word.inspect}\nIndices:#{indices.inspect}\nOccurences:#{occurences.inspect}"
		return rep
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
				if tweet.downcase.split.include? key
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
		if @original_target.include? (target)
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
			end
		end
		def print_most_used_words()
			@target_text_hash.each{|key, value| puts "#{key} : #{value}"  }
		end
		def print_tweets()
			puts @original_target
		end
		private :define_target, :define_target_arr, :create_word_obj
	end
end
CA = CrushAnalysis.new("WRIGHT_CRUSHES_asText.txt","WRIGHT_CRUSHES_asText.txt", "StopWords.txt")

puts CA.target_words_obj_arr[1].toString
puts CA.original_target_arr[1]
