require_relative 'Reservation'
require_relative 'Clients'

# Main configuration, see other files for more details

NR_PEOPLE = 5000
NR_FIRMS = 100
NR_IND = 1000
NR_CONFERENCES = 60
NR_WOKSHOPS_PER_CON_BASE = 5
NR_WOKSHOPS_PER_CON_VAR = 5

NR_RESERVATIONS_PER_CON_FIRMS_BASE = 5
NR_RESERVATIONS_PER_CON_FIRMS_VAR = 5

NR_RESERVATIONS_PER_CON_IND_BASE = 30
NR_RESERVATIONS_PER_CON_IND_VAR = 30

NR_RESERVATIONS_PER_WORK_BASE = 20
NR_RESERVATIONS_PER_WORK_VAR = 10

# People
people = Array.new
NR_PEOPLE.times{ people << Person.new }

# Clients
clientFirms = Array.new
NR_FIRMS.times{ clientFirms << CompanyClient.new }
clientInd = Array.new
NR_IND.times{ clientInd << IndClient.new }

# Conferences
conferences = Array.new
NR_CONFERENCES.times{ conferences << Conference.new}

# Now let's make a lookup table of which conference collides with which conference
cCollisions = Hash.new
conferences.each{|x| conferences.each{|y| cCollisions["#{x.id} #{y.id}"] = Conference.Collide x, y }}

# Workshops, randomizes number per conference
workshops = Array.new
conferences.each{|x| ((NR_WOKSHOPS_PER_CON_VAR*rand()).to_i + NR_WOKSHOPS_PER_CON_BASE).times{ workshops << Workshop.new(x)}}

# Now let's make a lookup table of which workshop collides with which workshop
wCollisions = Hash.new
workshops.each{|x| workshops.each{|y| wCollisions["#{x.id} #{y.id}"] = Workshop.Collide x, y }}



#Just to divide people into students and not students
normal = people.select{|x| x.nr == nil}
students = people.select{|x| x.nr != nil}
# Array of conference reservations
creservations = Array.new
# Array of workshop reservations
wreservations = Array.new

# Filling the conferences with reservations, fisrly for companies
conferences.each do |x|
	((NR_RESERVATIONS_PER_CON_FIRMS_VAR*rand()).to_i + NR_RESERVATIONS_PER_CON_FIRMS_BASE).times do
		creservations << CReservation.new(clientFirms.sample, x.days.sample)
	end
end

# And now for individuals
conferences.each do |x|
	((NR_RESERVATIONS_PER_CON_FIRMS_VAR*rand()).to_i + NR_RESERVATIONS_PER_CON_FIRMS_BASE).times do
		creservations << CReservation.new(clientInd.sample, x.days.sample)
	end
end 

# Now filling the conference reservations with conference reservations
workshops.each do |x| 
	# Conference reservations for a given workshop
	workConferencesRes = creservations.select{|cr| cr.conference == x.conference}
	((NR_RESERVATIONS_PER_WORK_VAR*rand()).to_i + NR_RESERVATIONS_PER_WORK_BASE).times do
		wreservations << WReservation.new(x, workConferencesRes.sample)
		# Added a workshop reservation
	end
end # Filling the conferences with reservations

# Array of conference participants
cparticipants = Array.new
# Array of workshop pariticipants
wparticipants = Array.new

# Now let's fill em up
# We will will every conference reservation with cparticipants, and then it's conference reservations
creservations.each do |x|
	# We will do this for every conference reservation
	# Firstly for individual reservations
	# INDIVIDUAL
	if x.client.instance_of?(IndClient) 
		cparticipant = CParticipant.new x, x.client.person
		cparticipants << cparticipant
		# Now for every workshop reservation refering to this conference reservation we will add one participant to it's workshop
		wreservations.select{|wres| wres.creservation = x}.each do |wres|
			wparticipants << (WParticipant.new wres, x.client)
			# Added a workshop participant for this workshop and for the client of this conference reservation
		end
		# For every workshop this client had a reservation, added him to the participants
	else
		# Here we got a company reservation
		# COMPANY
		# This are very important structures 
		# they contating the people already chosen to fill in for this reservation
		cParForThisConference = Array.new
		# Choosing some normal guys, not a students, to participate
		# AS FOR NOW THEY MAY HAVE SOME CONFLICTS WITH DIFFERENT CONFERENCES AND RESERVATIONS
		x.normal.times do
			guy = normal.sample # We choose a guy, not a student
			thisParticpant = (CParticipant.new x, guy)
			cparticipants << thisParticpant
			# Added the guy to the list
			cParForThisConference << thisParticpant
		end
		# Choosing some students, to participate
		# AS FOR NOW THEY MAY HAVE SOME CONFLICTS WITH DIFFERENT CONFERENCES AND RESERVATIONS
		x.students.times do
			guy = students.sample # We choose a guy, not a sample
			thisParticpant = (CParticipant.new x, guy)
			cparticipants << thisParticpant
			# Added the guy to the list
			cParForThisConference << thisParticpant
		end
		# The same thing, only for workshop reservations, student don't matter to me none :D	
		# the workshop participant structure doesn't differentiate from students
		# AS FOR NOW THEY MAY HAVE SOME CONFLICTS WITH DIFFERENT CONFERENCES AND RESERVATIONS

		# Now for every workshop reservation refering to this conference reservation we will add participants to it's workshop
		# choosing only the wreservations for this conference reservation
		wreservations.select{|wres| wres.creservation = x}.each do |wres|
			wres.places.times do
			wparticipants << (WParticipant.new wres, cParForThisConference.sample)
			# Added a workshop participant for this workshop and for the client of this conference reservation
			end
		end
		# We filled the whole stuff with people
		# They may have some conflicts
	end
end


#Printing
#=begin

peopleFile = File.new("export/Osoby.sql")
clientsFile = File.new("export/Klienci.sql")
conferencesFile = File.new("export/Konferencje.sql")
workshopsFile = File.new("export/Warsztaty.sql")
confReservationsFile = File.new("export/RezerwacjeKonf.sql")
workReservationsFile = File.new("export/RezerwacjeWarsz.sql")
confParticipantsFile = File.new("export/UczestnicyKonf.sql")
workParticipantsFile = File.new("export/UczestnicyWarsz.sql")
people.each{|x| peopleFile << x.export}
clientFirms.each{|x| clientsFile << x.export}
clientInd.each{|x| clientsFile << x.export}
conferences.each{|x| conferencesFile << x.export}
workshops.each{|x| workshopsFile << x.export}
creservations.each{|x| confReservationsFile << x.export}
wreservations.each{|x| workReservationsFile << x.export}
cparticipants.each{|x| confParticipantsFile << x.export}
wparticipants.each{|x| workParticipantsFile << x.export}
#=end

# Examples
=begin
conf = Conference.new
work = Workshop.new conf
cli = CompanyClient.new

cres = CReservation.new cli, conf.days[0]

wres = WReservation.new work, cres

guy = Person.new

cpar = CParticipant.new cres, guy

wpar = WParticipant.new wres, work

puts cpar.export
puts wpar.export
=end
