require './CrushAnalysis.rb'
if !File.exist?('saved_session')
  puts "Generating new session: "
  CA = CrushAnalysis.new("WRIGHT_CRUSHES_asText.txt","WRIGHT_CRUSHES_asText.txt", "StopWords.txt")
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
  puts "\sOptions:Find\tHTML\tReload Text\tPrint Tweets\tDelete\tSave"
  if (keyboard.include? "Find" or keyboard.include? "find")
    print "Enter the word you would like to find: "
    keyboard = STDIN.gets.chomp
    CA.find_context(keyboard)
  elsif keyboard.eql? "HTML" or keyboard.eql? "html"
    CA.generate_html()
    puts "HTML generated"
  elsif keyboard.eql? "Print" or keyboard.eql? "print"
    CA.print_tweets
  elsif keyboard.eql? "Delete" or keyboard.eql? "delete"
    File.delete("saved_session")
    puts "saved_session was deleted."
  elsif keyboard.eql? "Save" or keyboard.eql? "save"

    File.open('saved_session', 'w+') do |f|
      Marshal.dump(CA, f)
    end

  elsif keyboard.eql? "Reload" or keyboard.eql? "reload"
    prints "File to read from: "
    file=keyboard
    puts file.length
    print "Starting point"
    starting =keyboard
    print "Ending point"
    ending = keyboard
    CA.redefine_target_sector(file,starting,ending)

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

  end
  keyboard = STDIN.gets.chomp
end
