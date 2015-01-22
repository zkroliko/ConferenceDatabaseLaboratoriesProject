require 'faker'
require_relative "Person.rb"	

PASSW_LENGTH_MIN = 10
PASSW_LENGTH_MAX = 20

class Client
	@@curindex = 1

attr_accessor :curindex, :id, :person, :login, :password

	def initialize
		# Indexing stuff
		@id = @@curindex
		@@curindex +=1
		# Random values
		@person = Person.new
		@login = Faker::Internet.user_name
		@pass = Faker::Internet.password(PASSW_LENGTH_MIN,PASSW_LENGTH_MAX)
	end
end


class CompanyClient < Client
attr_accessor :companyName, :id, :phone, :fax, :email

	def initialize
		super
		# Child class fields initialization
		@companyName = Faker::Company.name + " " +  Faker::Company.suffix
		@phone = Faker::Number.number(TELEPHONE_N_LENGTH)
		@fax = Faker::Number.number(TELEPHONE_N_LENGTH)
		# Email is formated as company
		@email = "contact@#{@companyName}#{Faker::Lorem.word}.com".gsub(" ", "")
		@login = "#{@companyName}#{Faker::Lorem.word}".downcase.gsub(" ", "").gsub(",", " ")
	end

	def to_s
		"#{@person}, \"#{@companyName}\", #{@phone}, #{@fax}, \"#{@email}\", \"#{@login}\", \"#{@pass}\", 1"
	end
	def export
		"exec dbo.DodajKlientaFirm #{to_s};"
	end

end

class IndClient < Client
attr_accessor :companyName, :id, :phone, :fax, :email

	def initialize
		super
		# Child class fields initialization
		# Email is a bit different
		@email = "#{@person.firstName}#{@person.lastName}#{Faker::Lorem.word}@memail.com".downcase.gsub(" ", "")
		@login = "#{@person.firstName}#{@person.lastName}#{Faker::Lorem.word}".downcase.gsub(" ", "").gsub(",", " ")
	end

	def to_s
		"#{@person}, \"#{@email}\", \"#{@login}\", \"#{@pass}\", 0"
	end
	def export
		"exec dbo.DodajKlientaInd #{to_s};"
	end

end

