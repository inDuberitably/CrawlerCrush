require 'rubygems'
require 'watir-webdriver'
require "watir-webdriver/wait"
require './GetFollowers.rb'

target = ARGV[0]
puts "Loading login info from 'loginInfo.txt'"
=begin
load login info
=end
userInfo = File.open('loginInfo.txt')
loginInfo = []
userInfo.each_line do |w|
  w.split('\n').each {|x| loginInfo <<x}
end

puts "Logging in"
=begin
pass through the login
=end
#Watir::always_locate = true
#profile = Selenium::WebDriver::Firefox::Profile.new
#profile.native_events = false
browser = Watir::Browser.new :firefox
puts "using #{browser.name}\nopening: http://wings.wright.edu/cp/home/displaylogin"
browser.goto 'http://wings.wright.edu/cp/home/displaylogin'

browser.text_field(:name => 'user').set "#{loginInfo[0]}"

browser.text_field(:name => 'pass').set "#{loginInfo[1]}"

browser.button(:name => 'login_btn').click


=begin
Check if we're at the right url
=end
if browser.url == 'http://wings.wright.edu/render.userLayoutRootNode.uP?uP_root=root'
  puts "Login complete"
  browser.goto("http://www.wright.edu/wings/channels/search.html")
else
  puts "failed to login"
  exit
end

=begin
use followers from GetFollowers.rb
arr[6] = Major: Some university major
arr[4] = College: Some college
=end

WSU_Names = GetFollowers.new(target)
puts "#{WSU_Names.nothing_but_names.length} followers to be searched"
name_arr = WSU_Names.nothing_but_names
majors_txt =open("#WC_majors.txt", "w")
colleges_txt =open("#WC_colleges.txt", "w")
puts "Follower to start at: "
num = STDIN.gets.chomp
num = num.to_i
junk_arr = []
(num...name_arr.length).each do |k|
  junk_arr << name_arr[k]
end
name_arr = junk_arr
k = 0
i = name_arr.length # number of entries left to search
name_arr.each do |name|
  if browser.text_field(:name => 'q').exist?
    vip = name.scan(/\w+/)
    if vip.length >= 2
      puts "Searching for #{vip[0]} #{vip[1]}\t#{k}"
      browser.text_field(:name => 'q').set "#{vip[0]} #{vip[1]}"
      browser.send_keys :enter
      if browser.text.include? "Search Again?"
        name_bool = browser.text.include?(vip[0]) or browser.text.include?(vip[1])
        if !browser.text.include? "Nothing matches your search." and name_bool and browser.text.split(/\n/).length <=14
          arr = browser.text.split(/\n/)
          colleges_txt.write(arr[4] + "\n")
          majors_txt.write(arr[6] +"\n")
          puts "#{arr[6]}"
        elsif browser.text.split(/\n/).length > 14
          puts browser.text.split(/\n/).length
          puts "too many entries to determine major accurately."
        else
          puts "nada"
        end
      end
    else
      puts "nil"
    end
  else
    puts "Element does not exist"
  end
  browser.goto("http://www.wright.edu/wings/channels/search.html")
  i -=1
  k += 1
  puts "#{i} names to go"
end
