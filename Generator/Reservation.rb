#Reservation for conference
require_relative 'Workshop'

RESERVATION_BASE_QUOTA = 0.03
RESERVATION_VARY_QUOTA = 0.03

RESERVATION_BASE_QUOTA_WORKSHOP = 0.2
RESERVATION_VARY_QUOTA_WORKSHOP = 0.1

# This represent how long ago the reservation had been made
RESERVATION_DATE_BASE = 14 # In days
RESERVATION_DATE_VARY = 500 # In days

STUDENT_PROPORTION = 0.1

class CReservation

	@@curindex = 1

	attr_accessor :curindex, :id, :cday, :client, :reservationDate, :conference, :normal, :students, :payment

	def initialize (client, cday, normal = 0, students = 0)
		# Indexing
		@id = @@curindex
		@@curindex += 1	
		# Refence to client
		@client = client		
		# Confence day		
		@cday = cday
		# Random date of reseravtion
		@reservationDate = ((@cday.date)-(rand()*RESERVATION_DATE_VARY+RESERVATION_DATE_BASE).to_i)
		# Helpull field
		@conference = @cday.conference
		# Now let's make a decision on number of places on the reservation
		# The ammount of places is randomized based on constants
		# , the @leftPlaces field of conference is updated
	
		# If we are given a number of places we set them and quit
		if normal+students != 0
			@students = students
			@normal = normal
			return self
		end

		# If the conference day is out of left spaces, we will make an empty resevation
		if @cday.leftPlaces <= 0
			@students = 0
			@normal = 0
			return self
		end
		# If there are places left
		if @client.instance_of?(CompanyClient)
			# We are a company aparently
			places = (@conference.places*(RESERVATION_VARY_QUOTA*rand()+RESERVATION_BASE_QUOTA))%(@cday.leftPlaces)
			@cday.leftPlaces -= places.to_i # Substracting taken spaces
			if (@cdat.leftPlaces <0)
				@students = 0
				@normal = 0
			else
			@students = (places*STUDENT_PROPORTION).to_i
			# Lets check whether there is place left for students
			@normal = (places*(1-STUDENT_PROPORTION)).to_i
			end 
		else
			# We are private person
			# minus one places left on the conference
			@cday.leftPlaces -= 1
			# Now let's check if it's a student or not
			if (client.person.nr != nil)
				@students = 1
				@normal = 0
			else # The person is not a student
				@students = 0
				@normal = 1
			end
		end 
	end

	def to_s
		"#{(@client.id)}, #{(@conference.id)}, \"#{@reservationDate.to_s[0..10]}\", #{@students}, #{@normal}"
	end

	def export 
		"exec dbo.DodajRezerwacjeKonf #{to_s}"
	end
end

class WReservation

	@@curindex = 1

	attr_accessor :curindex, :id, :date, :workshop, :creservation, :client, :places

	def initialize(workshop, creservation, places = 0)
		@id = @@curindex
		@@curindex +=1
		@workshop = workshop
		@creservation = creservation
		@client = creservation.client
		# Now let's make a decision on number of places on the reservation
		# The ammount of places is randomized based on constants
		# , the @leftPlaces field of conference is updated
		if places == 0
			# Default value
			if (@client.instance_of?(CompanyClient) and @workshop.leftPlaces > 0)
				# We are a company aparently
				@places = ((@workshop.places*(RESERVATION_VARY_QUOTA_WORKSHOP*rand()+RESERVATION_BASE_QUOTA_WORKSHOP))%(@workshop.leftPlaces)).to_i
				if (@workshop.leftPlaces <=0)
					return nil
				end
			else
				# We are an individual person
				@places = 1
			end 

		else
			# If it's not 0 then we take the value given as parameter
			@places = places
		end
		# We always need to decrement the number of places left in the workshop
		@workshop.leftPlaces -= @places.to_i
	end

	def to_s
		"#{(@workshop.id)}, #{@creservation.id}, \"#{(@creservation.reservationDate).to_s[0..10]}\", #{@places}"
	end

	def export 
		"exec dbo.DodajRezerwacjeWarsztatu #{to_s}"
	end
end

#Conference participant
class CParticipant

	@@curindex = 1

	attr_accessor :curindex, :id, :date, :client, :creservation, :person

	def initialize(creservation, person)
		@id = @@curindex
		@@curindex +=1
		@client = creservation.client
		@creservation = creservation
		@person = person
	end

	def to_s
		"#{@client.id}, #{@creservation.id}, #{@person.id}"
	end

	def export 
		"exec dbo.DodajUczestnikaKonf #{to_s}"
	end
end

#Wokshop participant
class WParticipant

	@@curindex = 1

	attr_accessor :curindex, :id, :date, :client, :wreservation, :person

	def initialize(wreservation, cparticipant)
		@id = @@curindex
		@@curindex +=1
		@wreservation = wreservation
		@cparticipant= cparticipant
	end

	def to_s
		"#{@wreservation.id}, #{@cparticipant.id}"
	end

	def export 
		"exec dbo.DodajUczestnika #{to_s}"
	end
end

