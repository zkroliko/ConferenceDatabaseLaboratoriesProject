require_relative 'Reservation'
require_relative 'Clients'

# Main configuration, see other files for more details

NR_PEOPLE = 1000 #default 5000
NR_FIRMS = 400 #default 100
NR_IND = 1000 #default 1000
NR_CONFERENCES = 1 #default 72
NR_WOKSHOPS_PER_CON_BASE = 10 #default 5
NR_WOKSHOPS_PER_CON_VAR = 20 #default 5

NR_RESERVATIONS_PER_CON_FIRMS_BASE = 10 #default 10
NR_RESERVATIONS_PER_CON_FIRMS_VAR = 10 #default 10

NR_RESERVATIONS_PER_CON_IND_BASE = 60 #default 30
NR_RESERVATIONS_PER_CON_IND_VAR = 60 #default 30

NR_RESERVATIONS_PER_WORK_BASE = 60 #default 20
NR_RESERVATIONS_PER_WORK_VAR = 20 #default 10

#The ratio by which workshops are attended in a given conference
WORKSHOPS_ATTENDANCE_BASE = 1 #default 0.5
WORKSHOPS_ATTENDANCE_VARY = 0.0 #default 0.5 


# People
people = Array.new
NR_PEOPLE.times{ people << Person.new }

#Just to divide people into students and not students
normal = people.select{|x| x.nr == nil}
students = people.select{|x| x.nr != nil}

# Clients
clientFirms = Array.new
NR_FIRMS.times{ clientFirms << CompanyClient.new }
clientInd = Array.new
NR_IND.times{ clientInd << IndClient.new }

# Conferences
conferences = Array.new
NR_CONFERENCES.times{ conferences << Conference.new}

# Workshops, randomizes number per conference
workshops = Array.new
conferences.each{|x| ((NR_WOKSHOPS_PER_CON_VAR*rand()).to_i + NR_WOKSHOPS_PER_CON_BASE).times{ workshops << Workshop.new(x)}}

# Array of conference reservations
creservations = Array.new
# Array of workshop reservations
wreservations = Array.new
# Array of conference participants
cparticipants = Array.new
# Array of workshop pariticipants
wparticipants = Array.new


work1 = workshops.sample(5)

work2 = Workshop.pickNoncolliding work1
work2.each{|x| puts x.export}

return false

# We will have a one great loop for every conference
conferences.each do |cres|
	# First let's pick some companies and individual customers to parcipate in the conference
	# How many companies and how many ind clients
	howManyCompanies = ((NR_RESERVATIONS_PER_CON_FIRMS_VAR*rand()).to_i + NR_RESERVATIONS_PER_CON_FIRMS_BASE)
	howManyInd =  ((NR_RESERVATIONS_PER_CON_IND_VAR*rand()).to_i + NR_RESERVATIONS_PER_CON_IND_BASE)
	# Let's pick some Companies
	companiesForThisConference = clientFirms.sample(howManyCompanies)
	# Let's pick some ind customers
	indForThisConference = clientInd.sample(howManyInd)
	# Let's find workshops for this conference
	# they are created with proper dates
	workshopsInConference = workshops.select{|w| w.conference == cres} # Workshops in this conference

	# Now let's make a data structure to hold what workshops a given clients participates in
	workshopsForClient = Array.new
	clients = companiesForThisConference + indForThisConference
	# Filling each key with workshops
	clients.each do |cli|	
		# Number of workshops the client will be attending
		targetAmmountOfWorkshops = (workshopsInConference.size*(WORKSHOPS_ATTENDANCE_VARY*rand()+WORKSHOPS_ATTENDANCE_BASE)).to_i 
		# If the client is individual, we will check if they collide and try do to something about it
		if cli.instance_of?(IndClient)
			# This function will find a non-colliding substet of workshops at this conference
			workshopsForClient[cli.id] = Workshop.pickNoncolliding workshopsInConference, targetAmmountOfWorkshops
		else
		# If the client is a company, we have less trouble
		# We might have some trouble later on
		workshopsForClient[cli.id] = workshopsInConference.sample(targetAmmountOfWorkshops)
		end
	end	
end

=begin

# Filling the conferences with reservations, firstly for companies
conferences.each do |x|
	((NR_RESERVATIONS_PER_CON_FIRMS_VAR*rand()).to_i + NR_RESERVATIONS_PER_CON_FIRMS_BASE).times do
		creservations << CReservation.new(clientFirms.sample, x.days.sample)
	end
end

# And now for individuals
conferences.each do |x|
	((NR_RESERVATIONS_PER_CON_IND_VAR*rand()).to_i + NR_RESERVATIONS_PER_CON_IND_BASE).times do
		creservations << CReservation.new(clientInd.sample, x.days.sample)
	end
end 

creservations.each do |cres| # Filling the workshops with reservations from given conferences
	# We only fill the workshops one day in the conference
	if (cres.conference.days[0] == cres.cday)
		workshopsInConference = workshops.select{|w| w.conference == cres.conference} # Workshops in this conference
		# how many of the workshops will the client be attending
		ammountOfWorkshops = (workshopsInConference.size*(WORKSHOPS_ATTENDANCE_VARY*rand()+WORKSHOPS_ATTENDANCE_BASE)).to_i 
		workshopsForThisReservation = workshopsInConference.sample(ammountOfWorkshops) # A subset of the workshops
		workshopsForThisReservation.each do |work|
				wreservations << WReservation.new(work, cres)
				# Addding a workshop reservation
		end
	end
end


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
		wreservations.select{|wres| wres.creservation == x}.each do |wres|
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
		wreservations.select{|wres| wres.creservation == x}.each do |wres|
			wres.places.times do
			wparticipants << (WParticipant.new wres, cParForThisConference.sample)
			# Added a workshop participant for this workshop and for the client of this conference reservation
			end
		end
		# We filled the whole stuff with people
		# They may have some conflicts
	end
end

=end

#Printing

peopleFile = File.new("export/Osoby.sql", "w")
clientsFile = File.new("export/Klienci.sql", "w")
conferencesFile = File.new("export/Konferencje.sql", "w")
workshopsFile = File.new("export/Warsztaty.sql", "w")
confReservationsFile = File.new("export/RezerwacjeKonf.sql", "w")
workReservationsFile = File.new("export/RezerwacjeWarsz.sql", "w")
confParticipantsFile = File.new("export/UczestnicyKonf.sql", "w")
workParticipantsFile = File.new("export/UczestnicyWarsz.sql", "w")
people.each{|x| peopleFile << x.export << "\n"}
clientFirms.each{|x| clientsFile << x.export << "\n"}
clientInd.each{|x| clientsFile << x.export << "\n"}
conferences.each{|x| conferencesFile << x.export << "\n"}
workshops.each{|x| workshopsFile << x.export << "\n"}
creservations.each{|x| confReservationsFile << x.export << "\n"}
wreservations.each{|x| workReservationsFile <<  x.export << "\n"}
cparticipants.each{|x| confParticipantsFile << x.export << "\n"}
wparticipants.each{|x| 	workParticipantsFile << x.export << "\n"}
