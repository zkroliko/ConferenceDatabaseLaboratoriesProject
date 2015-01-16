require 'faker'
require_relative 'Supporting'
require_relative 'Conference'

WORKSHOP_PLACES_ROUNDING = -1
WORKSHOP_BASIC_PLACES = 10
WORKSHOP_VARIABLE_PLACES = 40

WORKSHOP_PRICE_ROUNDING = -1
WORKSHOP_BASIC_PRICE = 20
WORKSHOP_VARIABLE_PRICE = "dependant"
WORKSHOP_MAX_PRICE = 200

#How many workshop can there be per conference day
WORKSHOP_PER_CONF_DAY_BASE = 2
WORKSHOP_PER_CONF_DAY_MAX_DIFF = 2

#Maximal time worshop can take
WORKSHOP_MAX_LENGTH = 5

#In what time windows can workshops occur
WORK_HOUR_MIN = Time.new(2000, 01, 01, 8, 0, 0, "+01:00")
WORK_HOUR_MAX = Time.new(2000, 01, 01, 19, 0, 0, "+01:00")
#Maximal and minimal workshop length
WORK_TIME_MIN = 60*60 # in second
WORK_TIME_MAX = 240*60 # in second

class Workshop
	@@curindex = 1

	attr_accessor :curindex, :id, :name, :places, :price, :days

	def initialize(conference = 'null')
		@id = @@curindex
		@@curindex +=1
		@name = getSomeCoolName
		@places = (rand()*WORKSHOP_VARIABLE_PLACES).round(WORKSHOP_PLACES_ROUNDING)+WORKSHOP_BASIC_PLACES
		@price = (((Faker::Commerce.price).to_int+WORKSHOP_BASIC_PRICE)%WORKSHOP_MAX_PRICE).round(WORKSHOP_PRICE_ROUNDING)
		@conference = conference
		# Setting up the workshop days, randomizing start and end days
		startDate = Date.new
		endDate = Date.new
		while !((endDate-startDate) > 0 and (endDate-startDate) < WORKSHOP_MAX_LENGTH) do
			startDate = Faker::Date.between(conference.startDate, conference.endDate)
			endDate = Faker::Date.between(startDate, conference.endDate)
		end
		@choosenDays = (@conference.days).select{|x| x if (startDate <= x.date and x.date <= endDate)}
		# Now we have a subset of conference days
		@days = Array.new
		@choosenDays.each{|x| @days << (WDay.new((x), self))}
	end

	def getSomeCoolName
		names = File.open("NazwyWarsztatow").read.split("\n")
		names[rand(names.size)]
	end

	# Checks whether two Workshops collide
	def self.Collide first, second
		# Checking whether we have common days
		dayCollision = first.days.map{|x| x.cDay} & second.days.map{|x| x.cDay}
		if dayCollision.empty? 
			return false
		else	
			# There is an intersection
			# Now let's check for REAL intersections
			collision = dayCollision.select do |day|
				# Hell this is ugly
				firstStart = first.days[first.days.map{|x| x.cDay}.index(day)].startTime
				firstEnd= first.days[first.days.map{|x| x.cDay}.index(day)].endTime
				secondStart = second.days[second.days.map{|x| x.cDay}.index(day)].startTime
				secondEnd= second.days[second.days.map{|x| x.cDay}.index(day)].endTime
				if (firstStart > secondStart and firstStart < secondEnd) or (firstEnd > secondStart and firstEnd < secondEnd)
					return true # There is your problem!
				end
			end
		end
	end

	def to_s
		"\"#{name}\", #{@places}, \"#{@price}\""
	end

	def export 
		"exec dbo.DodajWarsztat #{to_s}\n#{(@days.collect{|x| x.export}).join("\n")}"
	end

end

class WDay
	@@curindex = 1

	attr_accessor :curindex, :id, :cDay, :workshop, :startTime, :endTime

	def initialize(cDay, workshop)
		@id = @@curindex
		@@curindex +=1
		@workshop = workshop
		@cDay = cDay
		# Now for staring and ending hours
		@startTime = (NormalizeTimeToDate(cDay.date, WORK_HOUR_MIN) + (rand()*((WORK_HOUR_MAX-WORK_HOUR_MIN)-WORK_TIME_MAX)).to_i).round(30*60)
		@endTime = (@startTime +rand()*WORK_TIME_MAX).round(30*60)
	end

	def to_s
		"#{@cDay.id}, #{(@workshop.id)}, \"#{@startTime.to_s[11..18]}\", \"#{@endTime.to_s[11..18]}\""
	end

	def export 
		"exec dbo.DodajDzienWarsztatu #{to_s}"
	end
end

#5.times{puts (Workshop.new(Conference.new)).export }

=begin
5.times {
a = Conference.new
b = Workshop.new(a)
c = Workshop.new(a)
puts b.export
puts c.export
puts Collide(b, c)
}
=end


