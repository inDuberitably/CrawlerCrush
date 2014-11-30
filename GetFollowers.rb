require './Follower.rb'
i = 1
target_text = "WRIGHT_CRUSHES_followers.txt"
target_file = File.open(target_text)
Follow = " Follow"
User_Actions = "User Actions"
follower_arr = []
arr = []
name = ""
handle =""
bio = ""
target_file.each_line do |line|
	if (!line.include? Follow and !line.include? User_Actions)
		arr << line
	end
end
i = 1
arr.each do |f|
	if (i == 2)
		name = f
		puts name
	elsif (i == 3)
		handle = f
		puts handle
	elsif (i == 4)
		bio = f
		puts bio
		follower =	Follower.new(name,handle,bio)
		follower_arr<<follower
	else
		i = 2
	end
	i += 1
end
