require './CrushAnalysis.rb'

def reload()
  puts "File to read from: "
  file=STDIN.gets.chomp
  count = %x{wc -l < "#{file}"}.to_i
  if (count > 0)
    puts "#{count} lines to be read from."
    puts "Starting point"
    starting = STDIN.gets.chomp
    puts "Ending point"
    ending = STDIN.gets.chomp
    CA.redefine_target_sector(file,starting.to_i,ending.to_i)
    puts "Reloaded with #{file}"
  end
end
def goto()
  puts "Tweet or Word?"
  keyboard = STDIN.gets.chomp
  if keyboard.eql? "tweet".downcase
    keyboard = STDIN.gets.chomp
    puts "\nTweet:"
    puts CA.tweet_arr(keyboard.to_i)
  elsif keyboard.eql? "word".downcase
    puts "Word to find:"
    keyboard = STDIN.gets.chomp
    puts CA[keyboard]
  else
    puts "unsupported operation"
  end
end
def help()
  puts File.read("help.txt")
end

if !File.exist?('saved_session')
  puts "Generating new session: "
  CA = CrushAnalysis.new("WRIGHT_CRUSHES_asText.txt", "StopWords.txt")
else
  File.open('saved_session') do |f|
    puts "saved_session loading..."
    CA = Marshal.load(f)
  end
end
print "\a"
puts "Press enter to begin:"
keyboard = STDIN.gets.chomp
while (true)
  puts "\sOptions:Find\tHTML\tReload Text\tPrint Tweets\tDelete\tSave\tHelp"
  keyboard.downcase!
  if (keyboard.include? "Find".downcase or keyboard.eql? "Find Deep".downcase)
    if(!keyboard.eql? "Find Deep".downcase)
      print "Enter the word you would like to find: "
      keyboard = STDIN.gets.chomp
      CA.find_context(keyboard)
    else
      puts "Enter the 1st word you would like to find: "
      word_one = STDIN.gets.chomp
      puts "Enter the 2nd word you would like to find: "
      word_two = STDIN.gets.chomp
      begin
        CA.deep_find_context(word_one, word_two)
      rescue  NoMethodError => e
      end
    end
  elsif keyboard.eql? "Stats".downcase
    CA.stats()

  elsif keyboard.eql? "HTML".downcase
    CA.generate_html()
    puts "HTML generated"
  elsif keyboard.eql? "Print".downcase
    CA.print_tweets
  elsif keyboard.eql? "Delete".downcase
    File.delete("saved_session")
    puts "saved_session was deleted."
  elsif keyboard.eql? "Save".downcase
    File.open('saved_session', 'w+') do |f|
      Marshal.dump(CA, f)
    end
    puts "saved_session created."
  elsif keyboard.eql? "Reload".downcase
    reload()
  elsif keyboard.eql? "go to".downcase
    goto()
  elsif keyboard.eql? "help".downcase
    help()
  end
  keyboard = STDIN.gets.chomp
end
