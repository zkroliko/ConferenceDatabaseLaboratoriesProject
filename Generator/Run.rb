require_relative 'Reservation'
require_relative 'Clients'

conf = Conference.new
work = Workshop.new conf
cli = CompanyClient.new

cres = CReservation.new cli, conf.days[0]

puts cres.export

10.times{puts (WReservation.new work, cres).export}
