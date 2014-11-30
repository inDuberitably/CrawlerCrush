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
end