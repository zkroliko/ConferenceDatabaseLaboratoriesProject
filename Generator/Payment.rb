require_relative 'Workshop'

# Payments for a given conference reservation
class CPayment
	@@curindex = 1

	attr_accessor :curindex, :id, :date, :client, :creservation, :person

	def initialize(creservation)
		@id = @@curindex
		@@curindex +=1
		@creservation = creservation
		# Some date between paying and the given day of conference - 7 days
		@date = Faker::Date.between(creservation.cday.date, creservation.conference.days[0].date - 7)
	end

	def to_s
		"#{@creservation.id}, \"#{@date.id}\", #{@sum.id}"
	end

	def export 
		"exec dbo.DodajOplate #{to_s}"
	end

	def calculateForConference
		@sum = @creservation.conference.price*(@creservation.normal+@creservation.students) 
	end
	
end
