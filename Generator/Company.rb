require 'faker'
require_relative "Person.rb"

class CompanyClient
attr_accessor :curindex, :id, :name

	def initialize
		@id = @@curindex
		@@curindex +=1
		@name = Faker::Company.Name
		@phone = Faker::Phone.phone
		@person = Person.new
	end



	def to_s
		"'#{@firstName}', '#{@lastName}', '#{@phone}', #{@dateOfBirth} #{@sex}, #{@nr} #{@address}"
	end
	def export
		"exec dbo.DodajOsobe #{to_s}; \n"
	end

end

