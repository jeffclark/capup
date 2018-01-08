require 'sidekiq'
require 'redis'

Sidekiq.configure_client do |config|
	config.redis = { :namespace => 'x', :size => 1}
end

class PlainOldRuby
	include Sidekiq::Worker

	def perform(how_hard="super hard", how_long=1)
		sleep how_long
		puts "Sidekiq Workin' #{how_hard}"
	end
end
