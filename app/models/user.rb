class User < ActiveRecord::Base

	before_create :generate_token
	has_one :api_key
	has_many :tasks

	private
	def generate_token
		self.api_key = ApiKey.create!
	end
end
