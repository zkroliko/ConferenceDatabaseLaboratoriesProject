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

# Making conference reservations

creservations = Array.new
conferences.each do |x| 
	((NR_RESERVATIONS_PER_CON_FIRMS_VAR*rand()).to_i + NR_RESERVATIONS_PER_CON_FIRMS_BASE).times do
		creservations << CReservation.new(clientFirms.sample, x.days.sample)
	end
end # This was supposed to be in one line but ran into some syntax bug :) 

wreservations = Array.new
workshops.each do |x| 
	((NR_RESERVATIONS_PER_WORK_VAR*rand()).to_i + NR_RESERVATIONS_PER_WORK_BASE).times do
		wreservations << WReservation.new(x, creservations.select{|cr| cr.conference == x.conference}.sample)
	end
end # Had to make a little query there

#Now, the hardest part will be filling these conferences and workshops with people

#Just to divide people into students and not students
normal = people.select{|x| x.nr == nil}
students = people.select{|x| x.nr != nil}
cparticipants = Array.new
creservations.each do |x|
	x.normal.times do
		cparticipants << (CParticipant.new x, normal.sample)
	end
	x.students.times do
		cparticipants << (CParticipant.new x, students.sample)
	end
end

wparticipants = Array.new
wreservations.each do |x|
		x.places.times{wparticipants << (WParticipant.new x, cparticipants.sample)}
end

#We have to do the whole thing differently just for ind customers
#Making a support array just for that
creservationsInd = Array.new
conferences.each do |x| 
	((NR_RESERVATIONS_PER_CON_IND_VAR*rand()).to_i + NR_RESERVATIONS_PER_CON_IND_BASE).times do
		creservationsInd << CReservation.new(clientInd.sample, x.days.sample)
	end
end
creservations << creservationsInd # Adding ind conference reservations to big table

## Addding individual conference participants to 
creservationsInd.each do |x|
		cparticipants << (CParticipant.new x, x.client.person)
end



#Printing
=begin
people.each{|x| puts x.export}
clientFirms.each{|x| puts x.export}
clientInd.each{|x| puts x.export}
conferences.each{|x| puts x.export}
workshops.each{|x| puts x.export}
creservations.each{|x| puts x.export}
wreservations.each{|x| puts x.export}
=end

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
