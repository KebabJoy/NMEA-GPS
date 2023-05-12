require 'nmea_plus'
require 'matplotlib/pyplot'

def calc_gap(sats, hdop, dphi, dlam, threshold, total_lon, total_lat, f = 1, plt)
  is_enough_sats = sats > 3
  is_frequent = f >= 1
  is_acc = hdop < 4
  is_dphi = dphi < threshold
  is_dlam = dlam < threshold
  result = is_enough_sats && is_frequent && is_acc && is_dphi && is_dlam

  pp total_lat
  pp total_lon

  if result
    plt.scatter(total_lon, total_lat, color: 'green', s: 10.0, alpha: 0.5)
  else
    plt.scatter(total_lon, total_lat, color: 'red', s: 10.0, alpha: 0.5)
  end

  pp(
    sats,
    hdop,
    dphi,
    dlam,
    threshold,
    result
  )

  result
end

lat2 = 55.7489
lon2 = 37.579
plt = Matplotlib::Pyplot

file = File.read('nmea.csv')
source_decoder = NMEAPlus::SourceDecoder.new(file)

source_decoder.each_complete_message do |message|
  if message.message_type == 'GGA'
    lat = message.latitude.to_f
    lon = message.longitude.to_f
    next if lat.zero? && lon.zero?

    num_s = message.satellites
    hdop = message.horizontal_dilution

    delta_lat = lat2 - lat
    delta_lon = lon2 - lon
    calc_gap(num_s.to_i, hdop.to_f, delta_lat.abs, delta_lon.abs, 0.0001, delta_lon, delta_lat, plt)
  end
end

plt.show
