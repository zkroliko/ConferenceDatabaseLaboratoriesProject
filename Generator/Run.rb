require_relative 'Reservation'
require_relative 'Clients'

# Examples

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

=begin

puts cres.export

10.times{puts (WReservation.new work, cres).export}
=end
