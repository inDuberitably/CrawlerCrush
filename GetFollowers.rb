require './Follower.rb'
=begin
makes the text file from the followers page given from twitter
=end
target_text = "WRIGHT_CRUSHES_followers.txt"
target_file = File.open(target_text)
Follow = " Follow"
User_Actions = "User Actions"
arr = []
name = ""
handle =""
bio = ""
target_file.each_line do |line|
  if (!line.include? Follow and !line.include? User_Actions)
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
follower_arr = []
target = ""
target_file.each_line do |w|
  w.split('\n').each {|x| arr <<x}
end
target_file.close
name = ""
handle = ""
bio = ""
while i <= arr.length
  name = arr[i]
  i+=1
  handle = arr[i]
  i+=1
  bio = arr[i]
  i+=1
follower_arr << Follower.new(name,handle,bio)
end