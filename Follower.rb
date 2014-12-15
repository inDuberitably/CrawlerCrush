require 'json'

class Follower
  attr_accessor :name, :handle, :bio
  def initialize(name, handle, bio)
    @name = name
    @handle = handle
    @bio = bio
  end
  def to_s
    "#{@name}\n#{@handle}\n#{@bio}"
  end
  def to_json(*a)
    {
      'json_class'   => self.class.name,
      'data'    => {"name" =>@name,"handle"=>@handle,"bio" =>@bio}
    }.to_json(*a)
  end

  def from_json(obj)
    json_obj = JSON.parse(obj)
    name =json_obj["data"]["name"]
    handle =json_obj["data"]["handle"]
    bio =json_obj["data"]["bio"]
    return Follower.new(name, handle, bio)
  end

end
