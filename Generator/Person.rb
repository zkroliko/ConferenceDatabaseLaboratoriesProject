require 'faker'
require_relative 'Address'

TELEPHONE_N_LENGTH = 9
PERSON_MIN_AGE = 18
PERSON_MAX_AGE = 65
STUDENT_QUOTA = 0.1 # How many of the people should be students
STUDENT_NR_LENGTH = 6

class Person
	@@curindex = 1
	attr_accessor :curindex, :id, :firstName, :lastName, :phone, :dateOfBirth, :nr, :address, :sex 

	def initialize
		@id = @@curindex
		@@curindex +=1
		@firstName = Faker::Name.first_name
		@lastName = Faker::Name.last_name
		@phone = Faker::Number.number(TELEPHONE_N_LENGTH)
		@dateOfBirth = Faker::Date.birthday(PERSON_MIN_AGE, PERSON_MAX_AGE)
		@sex = rand().round()
		@nr = studentNr
		@address = Address.new
	end

	def studentNr
		if (rand()<STUDENT_QUOTA) 			
			Faker::Number.number(STUDENT_NR_LENGTH)
		else
			 'null'
		end
	end

	def to_s
		"\"#{@firstName}\", \"#{@lastName}\", \"#{@phone}\", \"#{@dateOfBirth}\", #{@sex}, #{@nr}, #{@address}"
	end
	def export
		"exec dbo.DodajOsobe #{to_s}; \n"
	end
end

