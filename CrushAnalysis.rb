class CrushAnalysis
	def initialize (tweets,tweets_arr, stopwords)
		@original_target = define_target(tweets)
		@stop_word_dictionary = File.open(stopwords).read
		@stop_time_dictionary = File.open(stopwords).read
		@stop_time_arr = File.open(stopwords).read.split("\n")
		@stop_words_arr = File.open(stopwords).read.split("\n")
		@original_target_arr =define_target_arr(tweets_arr)
		@target_text_hash = create_hash(@original_target)
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

	def print_stop_words()
		puts @stop_words_arr
	end
	def find_context(target)
		if @original_target.include? (target)
			context = target.downcase
			arr = context.scan(/\w+/).flatten
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
		else
			puts "#{target} does not exist!"
		end
	end
	def print_most_used_words()
		@target_text_hash.each{|key, value| puts "#{key} : #{value}"  }
	end
	def print_unique_words()

	end
	def print_tweets()
		puts @original_target
	end

	def print_hash()
		puts @target_text_hash.inspect
		puts @target_text_hash.class
	end

	def print_arr()
		@original_target_arr.cycle(1){|x| puts x}
	end
	private :define_target, :define_target_arr
end

CA = CrushAnalysis.new("WRIGHT_CRUSHES_asText.txt","WRIGHT_CRUSHES_asText.txt", "StopWords.txt")

CA.print_hash
CA.find_context("Tim Horton")
CA.find_context("Scott Shirt Girl")
