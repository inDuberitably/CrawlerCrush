require './Follower.rb'

class GetFollowers
  def initialize(file)
    @follower_arr = get_follower_info(file)
    @follower_hash = generate_hash()
  end
  def nothing_but_names() #I get one free funny method name, right?
    return @follower_hash.keys
  end
  def follower_arr
    return @follower_arr
  end
  def [](index)
    return @follower_arr[index]
  end
  def follower_hash
    return @follower_hash
  end
  def get_follower_info(file)
=begin
makes the text file from the followers page given from twitter
parses out the ugly " Follow" and "User Actions"
=end
    target_text = file
    target_file = File.open(target_text)
    follow = " Follow"
    user_actions = "User Actions"
    arr = []
    name = ""
    handle =""
    bio = ""
    target_file.each_line do |line|
      if (!line.include? follow and !line.include? user_actions)
        arr << line
      end
    end
    target_file.close
    output = "WC_followers.txt"
    output_file = File.open(output, 'w+')
    arr.each do |f|
      output_file.write(f)
    end
    output_file.close

=begin
puts the followers into an array for later use
=end

    target_file=open('WC_followers.txt')
    i = 0
    arr = []
    @follower_arr = []
    target = ""
    target_file.each_line do |w|
      w.split('\n').each {|x| arr <<x}
    end
    target_file.close
    name = ""
    handle = ""
    bio = ""
    pt="Protected Tweets"
    while i < arr.length
      if arr[i].include? pt and arr[i].split(/\s/).length == 4 #check for protected tweet
        name_arr = arr[i].strip.split
        first_n = name_arr[0] + " "
        last_n = name_arr[1]
        last_n.gsub!(/[\W]/, "")
        first_n << last_n.strip
        name = first_n
        name.gsub!(/(\(|\[).+(\)|\])/,"")
        # [^:(:);)]
      elsif arr[i].split(/\s/).length == 2 #full name is already out in the open
        name = arr[i]

      elsif arr[i].include? "@" and arr[i].split.length == 1 #handle
        handle = arr[i]
      else #bio
        bio = arr[i]

        @follower_arr << Follower.new(name,handle,bio)
      end
      i+=1
    end

    return @follower_arr
  end
=begin
 remove names that may be duplicates.       
=end
  def generate_hash()
    @follower_hash = Hash[@follower_arr.map { |follower| [follower.name, follower]}]
  end
end
