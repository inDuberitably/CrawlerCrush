require 'rubygems'
require 'watir-webdriver'
require './GetFollowers.rb'

=begin
load login info
=end
userInfo = File.open('loginInfo.txt')
loginInfo = []
userInfo.each_line do |w|
  w.split('\n').each {|x| loginInfo <<x}
end


=begin
pass through the login
=end
browser = Watir::Browser.new :firefox

browser.goto 'http://wings.wright.edu/cp/home/displaylogin'

browser.text_field(:name => 'user').set "#{loginInfo[0]}"

browser.text_field(:name => 'pass').set "#{loginInfo[1]}"

browser.button(:name => 'login_btn').click


=begin
Check if we're at the right url
=end
if browser.url == 'http://wings.wright.edu/render.userLayoutRootNode.uP?uP_root=root'
  puts "login complete"
  browser.goto("http://www.wright.edu/wings/channels/search2.html")
else
  puts "failed to login"
  exit
end

=begin
use followers from GetFollowers.rb
=end

WSU_Names = GetFollowers.new()
if browser.text_field(:name => 'q').exist?
  browser.text_field(:name => 'q').set "#{WSU_Names[0].name}"
end