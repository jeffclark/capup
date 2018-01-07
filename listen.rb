require 'listen'
require 'sqlite3'

db = SQLite3::Database.new "test.db"

listener = Listen.to('/home/pi/www/capup', only: /\.ts$/) do |modified,added,removed|
	#only look for ts files
	#p "======="
	#puts "modified path: #{modified}"
	#puts "added path: #{added}"
	#puts "removed path: #{removed}"
	#p "-------"
	modified = modified.to_a
	added = added.to_a
	removed = removed.to_a

	if !added.empty?
		p "insert attempt? #{added[0]}"
		db.execute("INSERT INTO upload_queue (segment_path, status)
				VALUES (?, ?)", ["#{added[0]}", "capturing"])
		p "  - inserted"
	end

	if !modified.empty?
		p "update attempt? #{modified[0]}"
		db.execute("UPDATE upload_queue
			SET status = 'ready'
			WHERE segment_path = '#{modified[0]}'" )
		p "  - updated"
	end 

	if !removed.empty?
		p "removed #{removed[0]}"
	end
	p "  "
end
listener.start
sleep