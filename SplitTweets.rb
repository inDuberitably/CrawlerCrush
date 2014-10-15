some_text_file = File.open("WRIGHT_CRUSHES.txt")
tweets_arr = Array.new
someText = some_text_file.read

tweets_arr = someText.scan(/(\d+)/).flatten

tweets = File.open("tweets.txt", 'w+') do |f|
	tweets_arr.each{|e| f.puts(e)}
end