require './WordGraph'
class CrushAnalysis
  attr_accessor :target_text_hash, :target_words_obj_arr, :original_target_arr
  def initialize (tweets, stopwords)
    start = Time.now
    puts start
=begin
Start the default amount of tweets to be discovered.
The higher the value, the higher the computation time.            
=end
    @original_target = define_target(tweets,0,250)
    @stop_word_dictionary = File.open(stopwords).read
    @stop_words_arr = File.open(stopwords).read.split("\n")
    @original_target_arr =define_target_arr(tweets)
    @target_text_hash = create_hash(@original_target)
    @target_words_obj_arr = create_word_obj()
    @word_adjacency_list = generate_graph()
    finish = Time.now
    puts finish
  end
  def redefine_target_sector(target,start,finish)
    puts "redefining target"
    @original_target = define_target(target, start,finish)
    @original_target_arr =define_target_arr(target)
    puts "redefining hash"
    @target_text_hash = create_hash(@original_target)
    puts "redefining Word Objects"
    @target_words_obj_arr = create_word_obj()
    puts "redefining Word Graph"
    @word_adjacency_list = generate_graph()
  end

  def define_target(tweets,start,finish)
    tweety = IO.readlines(tweets)
    i = start
    @original_target = ""
    while i <= finish
      @original_target << tweety[i]
      i +=1
    end
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

      words = txt.scan(/[(\W+'\w+)]([^ -?".!@,():;]*)/).flatten.select{|w| w.length > 2}
      words.each do |word|
        if !@stop_words_arr.include?(word.downcase)
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
      @original_target_arr.each do |tweet|
        tweet.gsub!(/["]/, "")
        tweet.downcase!
        tweet_by_words = tweet.split(' ')
        if tweet_by_words.include? key
          temp_arr[x] = i
          x += 1
        end
        i += 1
        word_obj.occurences = temp_arr.length
        word_obj.indices = temp_arr.compact
      end
      words_arr << word_obj
    end
    return words_arr.sort{|w1,w2| w1.occurences <=> w2.occurences}.reverse
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

  def print_tweets()
    puts @original_target
  end

  def print_graph_neighbors()
    puts @word_adjacency_list.nodes_with_neighbors()
  end

  def find_context(target_context)
    if @original_target.downcase.include? target_context.downcase or !@word_adjacency_list.has_node(target_context)
      begin
        clue =  @word_adjacency_list.recover_node(target_context)
        self.print_indices(clue.word)
        puts "#{clue.rep}#{clue.to_s}\n"
        return clue
      rescue Exception => e
        puts "#{target_context}\n we'll find partial context soon\nOR\n \"#{target_context}\" is in the stop_word_dictionary"
        return nil
      end
    else
      puts "couldn't find #{target_context} :("
    end
  end


  def deep_find_context(word_one,word_two)
    word_one = find_context(word_one)
    word_two = find_context(word_two)
    if (!word_one.nil? or !word_two.nil?)
      deep_word = WordObj.new("", 0, [])
      deep_word.indices = word_one.indices & word_two.indices
      deep_word.word = word_one.word + " & " + word_two.word
      deep_word.occurences = deep_word.indices.length
      @word_adjacency_list.add_node(deep_word)
      self.print_indices(deep_word.word)
      puts "#{deep_word.rep}"
      puts "Added #{deep_word.word} to the list"
      return deep_word
    else
      puts "one value returned null"
    end
  end
  def tweet_arr(index)
    return original_target_arr[index]
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

  def edit(word,new_word)
   word = find_context(word)
    if !word.nil?
      @word_adjacency_list.remove_node(word)
      word.word = new_word
      @word_adjacency_list.add_node(word)
      return true
    end
    return false
  end

  def stats()
    @target_text_hash.each do |w|
      puts "#{w[0]}:\t#{w[1]}"
    end
    puts "TWENTY MOST USED WORDS LOLOL"
    v = @target_text_hash.values.reverse[0..20]
    h = @target_text_hash.keys.reverse[0..20]
    Hash[h.zip(v)].sort_by{|k,v|v}.each do |w|
      puts "#{w[0]}:\t#{w[1]}"
    end

    puts "\nNumber of total words used:"
    puts @target_text_hash.inject(0){|sum, w| sum += w[1]}
    puts "\nNumber of different words:"
    puts @target_text_hash.length
    puts "\nLongest word:"
    puts @target_text_hash.max_by{|k,v| k.length}[0]

  end
  def assoc_deep(word_one,word_two)
    word_one = find_context(word_one)
    word_two = find_context(word_two)
    if (!word_one.nil? or !word_two.nil?)
      deep_word = WordObj.new("", 0, [])
      deep_word.indices = word_one.indices | word_two.indices
      deep_word.word = word_one.word + " + " + word_two.word
      deep_word.occurences = deep_word.indices.length
      #deep_word.child << word_one.word
      #deep_word.child << word_two.word
      @word_adjacency_list.add_node(deep_word)
      self.print_indices(deep_word.word)
      puts "#{deep_word.rep}"
      puts "Added #{deep_word.word} to the list"
      return deep_word
    else
      puts "one value returned null"
    end
  end

  def define_averages_arr()
    averages_arr = []
    @original_target_arr.occurences.each do |occ|
      averages_arr << occ / original_target_arr.length
    end
    return averages_arr
  end
  def generate_html()
    color_list = File.open("colors.txt").read.split("\n")
    i = 0
    paragraph_class_list = []
    each_word_list = []
    each_word_color_list = []
    count = %x{wc -l < "colors.txt"}.to_i
    generator = Random.new
    font_size_list = ["50%","75%","100%", "150%", "200%", "250%", "300%"]
    while i < 250
      rand_color = generator.rand(0...count)
      each_word = ".a-#{i}"
      if i == 0 or i == 1
        each_word_color="{\n\tcolor: #{color_list[rand_color]}; font-size: #{font_size_list[6];}\n\n} \n\n"
      elsif i > 1 and i <=10
        rand_size = generator.rand(3...5)
        each_word_color="{\n\tcolor: #{color_list[rand_color]}; font-size: #{font_size_list[rand_size];}\n\n} \n\n"
      else
        rand_size = generator.rand(0...2)
        each_word_color="{\n\tcolor: #{color_list[rand_color]}; font-size: #{font_size_list[rand_size];}\n\n} \n\n"
      end
      paragraph_class = "<span class=\"a-#{i}\">#{@target_words_obj_arr[i].word}</span>\n"
      each_word_list << each_word
      each_word_color_list << each_word_color
      paragraph_class_list << paragraph_class
      i += 1
    end
    hashed_list = Hash[each_word_list.zip(each_word_color_list)]
    hashed_dump = ""
    hashed_list.each do |kl, vl|
      hashed_dump = hashed_dump + kl + vl
    end
    para = ""
    paragraph_class_list.shuffle!
    paragraph_class_list.each do |v|
      para = para + v
    end
    text =
    "<!DOCTYPE html>
<html>
<head>
<style>
body {
    color: #{color_list[0]};
}
h1 {
    color: #000000;
}
#{hashed_dump}</style>
</head>
<body>
<h1>Results</h1>
<p>
#{para}
</p>
</body>
</html>"
    most_used_words = File.open("most_used_words.html", "w")
    most_used_words.write(text)
    most_used_words.close()
  end
  def colorize_tweet(tweet_index)
    puts "#{tweet_index}"
    color_list = File.open("colors.txt").read.split("\n")
    i = 0
    paragraph_class_list = []
    each_word_list = []
    each_word_color_list = []
    count = %x{wc -l < "colors.txt"}.to_i
    tweet = @original_target_arr[tweet_index.to_i]
    puts tweet
    tweet_sentence = tweet.split("\s")
    puts tweet_sentence
    generator = Random.new
    font_size_list = ["50%","75%","100%", "150%", "200%", "250%", "300%"]
=begin
    tweet_sentence.each do |word|
      each_word = ".a-#{i}"
      rand_color = generator.rand(0...count)
      rand_size = generator.rand(0...font_size_list.list)

      if()
        each_word_color="{\n\tcolor: #{color_list[rand_color]}; font-size: #{font_size_list[rand_size];}\n\n} \n\n"
        paragraph_class = "<span class=\"a-#{i}\">#{word}</span>\n"
        each_word_list << each_word
        each_word_color_list << each_word_color
        paragraph_class_list << paragraph_class
        i+=1
      end
    end
  end
  hashed_list = Hash[each_word_list.zip(each_word_color_list)]
  hashed_dump = ""
  hashed_list.each do |kl, vl|
    hashed_dump = hashed_dump + kl + vl
  end
  para = ""
  paragraph_class_list.shuffle!
  paragraph_class_list.each do |v|
    para = para + v
  end
  text =
  "<!DOCTYPE html>
<html>
<head>
<style>
body {
    color: #{color_list[0]};
}
h1 {
    color: #000000;
}
#{hashed_dump}</style>
</head>
<body>
<h1>Results</h1>
<p>
#{para}
</p>
</body>
</html>"
  most_used_words = File.open("tweet_#{tweet_index}.html", "w")
  most_used_words.write(text)
  most_used_words.close()
=end
  end
  private  :define_target, :create_word_obj, :generate_graph

end
