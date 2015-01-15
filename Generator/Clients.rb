require 'faker'
require_relative "Person.rb"

class Client
	@@curindex = 1

attr_accessor :curindex, :id, :person, :person, :login, :password

	def initialize
		@id = @@curindex
		@@curindex +=1
		@person = Person.new
		@login = Faker::Internet.user_name
		@pass = Faker::Internet.password(10,20)
	end
end


class CompanyClient < Client
attr_accessor :companyName, :phone, :fax, :email

	def initialize
		super
		@companyName = Faker::Company.name + " " +  Faker::Company.suffix
		@phone = Faker::Number.number(9)
		@fax = Faker::Number.number(9)
		@email = "contact@#{@companyName}.com".gsub(" ", "")
		@login = @companyName.downcase.gsub(" ", "").gsub(",", " ")
	end

	def to_s
		"#{@person}, \"#{@companyName}\", #{@phone}, #{@fax}, \"#{@email}\", \"#{@login}\", \"#{@pass}\", 1"
	end
	def export
		"exec dbo.DodajKlientaFirme #{to_s}; \n"
	end

end

20.times {puts CompanyClient.new.export}

