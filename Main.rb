require 'CrushAnalysis.rb'

CA = CrushAnalysis.new("WRIGHT_CRUSHES_asText.txt","WRIGHT_CRUSHES_asText.txt", "StopWords.txt")
print "\a"
keyboard = STDIN.gets.chomp
puts "Options:\nFind\nHTML\nPrint Tweets\nGo To\nLoad\nSave"
while (true)
  puts "Options:\nFind\nHTML\nPrint Tweets\nLoad\nSave"
  if (keyboard.include? "Find" or keyboard.include? "find")
    print "Enter the word you would like to find: "
    keyboard = STDIN.gets.chomp
    CA.find_context(keyboard)
  elsif keyboard.eql? "HTML" or keyboard.eql? "html"
    CA.generate_html()
    puts "HTML generated"
  elsif keyboard.eql? "Print" or keyboard.eql? "print"
    CA.print_tweets
  elsif keyboard.eql? "Load" or keyboard.eql? "load"

    puts "unsupported operation"

  elsif keyboard.eql? "Save" or keyboard.eql? "save"

    puts "unsupported operation"

  elsif keyboard.eql? "go to" or keyboard.eql? "Go To"
    puts "Tweet or Word?"
    keyboard = STDIN.gets.chomp
    if keyboard.eql? "tweet" or keyboard.eql? "Tweet"
      print "\nWord:"
      puts "unsupported operation"
    elsif keyboard.eql? "word" or keyboard.eql? "Word"
      print "\nWord:"
      puts CA[keyboard]
    else
      puts "unsupported operation"
    end

  else
    puts "#{keyboard} not supported."

    keyboard = STDIN.gets.chomp
  end
end
