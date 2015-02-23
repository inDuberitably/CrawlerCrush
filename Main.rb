require './CrushAnalysis.rb'

def reload()
  puts "File to read from: "
  file=STDIN.gets.chomp
  count = %x{wc -l < "#{file}"}.to_i
  if (count > 0)
    puts "#{count} lines to be read from."
    puts "Starting point"
    starting = STDIN.gets.to_i
    puts "Ending point"
    ending = STDIN.gets.to_i
    CA.redefine_target_sector(file,starting,ending)
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
  puts "File Name:"
  file_name = STDIN.gets.chomp
  CA = CrushAnalysis.new(file_name, "StopWords.txt")
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
  elsif keyboard.eql? "Combine".downcase
    puts "Enter the 1st word you would like to find: "
    word_one = STDIN.gets.chomp
    puts "Enter the 2nd word you would like to find: "
    word_two = STDIN.gets.chomp
    begin
      CA.assoc_deep(word_one,word_two)
    rescue  NoMethodError => e
    end
  elsif keyboard.eql? "Colorize".downcase
    puts "Tweet ID: "
    index = STDIN.gets.chomp
    puts "you wanted this index #{index}"
    CA.colorize_tweet(index)

  elsif keyboard.eql? "HTML".downcase
    CA.generate_html()
    puts "HTML generated"
  elsif keyboard.eql? "edit".downcase

    puts "Enter the word you would like to edit"
    word = STDIN.gets.chomp
    puts "Enter the new name for \"#{word}\""
    new_word = STDIN.gets.chomp
    puts     CA.edit(word,new_word)


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

  elsif keyboard.eql? "Save as".downcase

    puts "Save as...?"
    keyboard = STDIN.gets.chomp
    file_name = "#{keyboard}_saved_session"
    File.open(file_name, 'w+') do |f|
      Marshal.dump(CA, f)
    end

  elsif keyboard.eql? "Load".downcase
    puts "Load ..."
    keyboard = STDIN.gets.chomp
    File.open("#{keyboard}") do |f|
      puts "saved_session loading..."
      CA = Marshal.load(f)
    end
  elsif keyboard.eql? "go to".downcase
    goto()
  elsif keyboard.eql? "help".downcase
    help()
  elsif keyboard.eql? "average".downcase
    CA.average_occ
  end
  keyboard = STDIN.gets.chomp
end
