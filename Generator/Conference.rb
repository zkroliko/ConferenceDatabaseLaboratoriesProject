require 'faker'
#require_relative 'Workshop'

#How many days backward can history go
CONFERENCE_START = 1000
#Seed for length
CONFERENCE_DAYS_MAX_DIFF = 5
CONFERENCE_DAYS_BASIC = 4

#Seed for places
PLACES_ROUNDING = -1
BASIC_PLACES = 300
VARIABLE_PLACES = 200

#Seed for price
PRICE_ROUNDING = -1
BASIC_PRICE = 10
VARIABLE_PRICE = "dependant"
MAX_PRICE = 100

#There are always 3 discount options
DISCOUNT_DAYS = [60, 120, 180, 360]
DISCOUNT_DAYS_MAX_DIFF = 10 
DISCOUNT_AMMOUNTS = [0.05, 0.10, 0.15]
DISCOUNT_AMMOUNTS_MAX_DIFF = 0.05

class Conference
	@@curindex = 1

	attr_accessor :curindex, :id, :name, :startDate, :endDate, :places, :price, :days, :discounts

	def initialize()
		# Indexing
		@id = @@curindex
		@@curindex +=1	
		# Name and number of places will be randomized
		@name = getSomeCoolName
		@places = (rand()*VARIABLE_PLACES).round(PLACES_ROUNDING)+BASIC_PLACES
		# Price for the conference
		@price = (((Faker::Commerce.price).to_int+BASIC_PRICE)%MAX_PRICE).round(PRICE_ROUNDING)
		makeDays # Procedure for making conference days, and discount schelude
	end
	
	# Makes some "clever" days for the conference along with discounts
	def makeDays
		howManyDaysAgo = (rand()*CONFERENCE_START).round(0)+18
		lengthDays = (rand()*CONFERENCE_DAYS_MAX_DIFF).round() + CONFERENCE_DAYS_BASIC
		@startDate = (Date.today-howManyDaysAgo)
		@endDate = (Date.today-howManyDaysAgo+lengthDays)
		# That's the end of fields you want to print	
		@days = Array.new
		(howManyDaysAgo-lengthDays..howManyDaysAgo).each{|x| @days << (CDay.new((Date.today-x), self))	}
		@days.reverse! # If we want them in correct order
		# Discounts, some weird stuff may happen here, like functional programming
		@discounts = Array.new
		days = DISCOUNT_DAYS.map{|x| x+((rand()-0.5)*DISCOUNT_DAYS_MAX_DIFF).round(0)}
		ammounts = DISCOUNT_AMMOUNTS.map{|x| x+((rand()-0.5)*DISCOUNT_AMMOUNTS_MAX_DIFF).round(2)}
		(0..2).each{|x| @discounts << Discount.new(((@startDate)-days[x].to_i-1), ((@startDate)-days[x+1].to_i), self, ammounts[x])}
	end

	# Opens a file to find some nome name for the conference
	def getSomeCoolName
		names = File.open("NazwyKonferencji").read.split("\n")
		names[rand(names.size)]
	end

	# Checks whether two conferences collide
	def self.Collide first, second
		# Checking whether we have common days
		dayCollision = first.days.map{|x| x.date} & second.days.map{|x| x.date}
		if dayCollision.empty? do 
			return false
		end
		else
			return true
		end
	end

	def to_s
		"\"#{@name}\", \"Konferencja\", \"#{@startDate}\", \"#{@endDate}\", \"#{@places}\", \"#{@price}\""
	end

	def export 
		"exec dbo.DodajKonferencje #{to_s}\n#{(@days.collect{|x| x.export}).join("\n")}\n#{(@discounts.collect{|x| x.export}).join("\n")}"
	end
end

#Days of the conference
class CDay
	@@curindex = 1

	attr_accessor :curindex, :id, :date, :conference, :places

		# Special accesor for :leftPlaces, because they can run out
	def leftPlaces=(leftPlaces)
    		@leftPlaces = leftPlaces
		if (leftPlaces < 0)
			"We ran out of space at this conference day"		
		end
 	end
		# Special accesor for :leftPlaces
	def leftPlaces
    		@leftPlaces
	end	
	
	def initialize(date, conference)
		# Indexing
		@id = @@curindex
		@@curindex +=1
		# Date type object
		@date = date
		# Refernce to "father" conference
		@conference = conference
		# Places for a given day, equal to places on the conference
		@places = @conference.places
		# We will make things easier by remebering how many places there ale left
		@leftPlaces = @places
	end

	def to_s
		"#{(@conference.id)}, \"#{@date.to_s[0..10]}\""
	end

	def export 
		"exec dbo.DodajDzienKonf #{to_s}"
	end
end

# For discountss
class Discount
	@@curindex = 1

	attr_accessor :curindex, :id, :date

	def initialize(startDate, endDate, conference, ammount)
		# Indexes
		@id = @@curindex
		@@curindex +=1
		# Dates for discount
		@startDate = startDate
		@endDate = endDate
		# Ammount, a float
		@ammount = ammount
		# Conferences to which price the discount should be applied
		@conference = conference
	end

	def to_s
		"#{(@conference.id)}, \"#{@endDate.to_s[0..10]}\", \"#{@startDate.to_s[0..10]}\", \"#{@ammount}\""
	end

	def export 
		"exec dbo.DodajZnizke #{to_s}"
	end

end

