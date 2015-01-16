require_relative 'Reservation'
require_relative 'Clients'

conf = Conference.new
cli = CompanyClient.new

40.times{puts (CReservation.new cli, conf.days[0]).export}
