require_relative 'Reservation'
require_relative 'Clients'

# Main configuration, see other files for more details

NR_PEOPLE = 1000 #default 5000
NR_FIRMS = 400 #default 100
NR_IND = 1000 #default 1000
NR_CONFERENCES = 1 #default 72

NR_WOKSHOPS_PER_CON_BASE = 5 #default 5
NR_WOKSHOPS_PER_CON_VAR = 5 #default 5

NR_RESERVATIONS_PER_CON_FIRMS_BASE = 10 #default 10
NR_RESERVATIONS_PER_CON_FIRMS_VAR = 10 #default 10

NR_RESERVATIONS_PER_CON_IND_BASE = 60#60 #default 30
NR_RESERVATIONS_PER_CON_IND_VAR = 60 #60 #default 30

NR_RESERVATIONS_PER_WORK_BASE = 60 #default 20
NR_RESERVATIONS_PER_WORK_VAR = 20 #default 10

#The ratio by which workshops are attended in a given conference
WORKSHOPS_ATTENDANCE_BASE = 0.5 #default 0.5
WORKSHOPS_ATTENDANCE_VARY = 0.5 #default 0.5 


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

# We will have a one great loop for every conference
conferences.each do |conf|
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
	workshopsInConference = workshops.select{|w| w.conference == conf} # Workshops in this conference

	# Now let's make a data structure to hold what workshops a given clients participates in
	workshopsForClient = Array.new
	clients = companiesForThisConference + indForThisConference
	# Filling each key with workshops
	clients.each do |cli|	
		# Number of workshops the client will be attending
		targetAmmountOfWorkshops = (workshopsInConference.size*(WORKSHOPS_ATTENDANCE_VARY*rand()+WORKSHOPS_ATTENDANCE_BASE)).to_i 
		# If the client is individual, we will take non-colliding subset of wokrshops
		if cli.instance_of?(IndClient)
			# This function will find a non-colliding substet of workshops at this conference
			workshopsForClient[cli.id] = Workshop.pickNoncolliding workshopsInConference, targetAmmountOfWorkshops
			# Well, now we can go on, and make all aragements
			# First let's make reservations for every day that contatins our workshops
			resWDays = workshopsForClient[cli.id].collect{|x| x.days}.flatten # Array of this workshops days
			resCDays = resWDays.map{|x| x.cday}.uniq # Mapped from this workshops days
			# It's important to make them unique
			# Lets make the proper number of clients
			if cli.person.nr == nil
				students = 0
				normal = 1
			else
				students = 1
				normal = 0
			end
			# Now lets make reservations
			thisCReservations = Array.new
			resCDays.each do |day| 
				thisCReservations << (CReservation.new cli, day, normal, students)	
				cparticipants << (CParticipant.new thisCReservations.last, cli.person)
			end
			# Adding them to a big pile
			creservations += thisCReservations
			# Now the reservation for workshops
			# We only make one, for the first day

			thisWreservations = Array.new
			workshopsForClient[cli.id].each do |work|	
				# We will add a reservation with the conference day reservation which is the first in the
				# conference, this workshop and 1 place
				thisWreservations << (WReservation.new work, thisCReservations.find{|x| x.cday === work.days.first.cday}, 1)
				# Now let's make participants
				thisWreservations.each do |wres|
					wparticipants << (WParticipant.new wres, cli.person)
				end
			end
			# Add them to a big pile now
			wreservations += thisWreservations 	
			# All done now
		else
			# If the client is a company, we have less trouble
			# We also select them non collidngly
			workshopsForClient[cli.id] = Workshop.pickNoncolliding workshopsInConference, targetAmmountOfWorkshops
			# First let's select every day that contatins our workshops
			resWDays = workshopsForClient[cli.id].collect{|x| x.days}.flatten # Array of this workshops days
			resCDays = resWDays.map{|x| x.cday}.uniq # Mapped from this workshops days
			# Now let's make reservations
			thisCReservations = Array.new
			# Making just one reservation
			thisCReservations << (CReservation.new cli, resCDays.first)
			nStudents = thisCReservations[0].students
			nNormal = thisCReservations[0].normal
			# Now we will propagate these number thruought the rest of the reservation
			resCDays[1..-1].each do |day|
				thisCReservations << (CReservation.new cli, day, nNormal, nStudents)
			end
			# Taking some people
			thisStudents = students.sample(nStudents)	
			thisNormal = normal.sample(nNormal)
			# Now making them participants
			thisCReservations.each do |res|
				thisStudents.each {|x| cparticipants << (CParticipant.new res, x)}
				thisNormal.each {|x| cparticipants << (CParticipant.new res, x)}
			end
			# Adding them to a big pile
			creservations += thisCReservations

			# Now the reservation for workshops
			# We only make one, for the first day
			thisWreservations = Array.new
			workshopsForClient[cli.id].each do |work|	
				# We will add a reservation with the conference day reservation which is the first in the
				# conference, this workshop and 1 place
				thisWreservations << (WReservation.new work, thisCReservations.find{|x| x.cday === work.days.first.cday}, nStudents+nNormal)
				# Now let's make participants
				thisWreservations.each do |wres|
					thisStudents.each {|x| wparticipants << (WParticipant.new wres, x)}
					thisNormal.each {|x| wparticipants << (WParticipant.new wres, x)}
				end
			end
			# Add them to a big pile now
			wreservations += thisWreservations 	
			# All done now
		end
	end	
end

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
