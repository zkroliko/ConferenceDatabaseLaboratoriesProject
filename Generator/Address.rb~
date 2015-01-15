require 'faker'
class Country
	@@curindex = 1

	attr_accessor :curindex, :id, :name

	def initialize()
		@id = @@curindex
		@@curindex +=1
		@name = Faker::Address.country
	end

	def to_s
		"\"#{name}\""
	end
end

class City
	@@curindex = 1

	attr_accessor :curindex, :id, :name, :country

	def initialize()
		@id = @@curindex
		@@curindex +=1
		@name = Faker::Address.city
		@country = Country.new
	end
	def to_s
		"#{@country}, \"#{@name}\""
	end
end

class Address
	@@curindex = 1

	attr_accessor :curindex, :id, :name, :city

	def initialize()
		@id = @@curindex
		@@curindex +=1
		@city = City.new
		@zip = Faker::Address.zip
		@street = Faker::Address.street_name
		@bNumber = Faker::Number.number(2).to_i+1
		@aNumber = Faker::Number.number(2).to_i+1
	end
	def to_s
		"#{@city}, \"#{@zip}\", \"#{@street}\", #{@bNumber}, #{@aNumber}"
	end
	# Exportownanie do polecenia sqlowego
	def export
		"exec dbo.DodajAdres #{to_s}; \n"
	end
end
