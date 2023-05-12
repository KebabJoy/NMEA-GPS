import pynmea2
import matplotlib.pyplot as plt

def calcGap(sats, hdop, dphi, dlam, threshold, total_lon, total_lat, f = 1):
    isEnoughSats = sats > 3
    isFrequent = f >= 1
    isAcc = hdop < 4
    isDphi = dphi < threshold
    isDlam = dlam < threshold
    result = isEnoughSats and isFrequent and isAcc and isDphi and isDlam
    if result:
        plt.scatter(total_lon, total_lat, color='green', s=10, alpha=0.5)
    else:
        plt.scatter(total_lon, total_lat, color='red', s=10, alpha=0.5)
    print(
        sats,
        hdop,
        dphi,
        dlam,
        threshold,
        result
    )
    return result

filename = "nmea.csv"

lat2 = 55.7489
lon2 = 37.579

with open(filename, 'r') as f:
    for line in f:
        if line.startswith('$GPGGA'):
            msg = pynmea2.parse(line)
            lat = float(msg.latitude)
            lat_dir = msg.lat_dir
            lon = float(msg.longitude)
            lon_dir = msg.lon_dir
            if lat == 0 and lon == 0:
                continue
            num_s = msg.data[6]
            hdop = msg.data[7]
            total_lat = lat2 - lat
            total_lon = lon2 - lon
            calcGap(int(num_s), float(hdop), abs(total_lat), abs(total_lon), 0.0001, total_lon, total_lat)

plt.show()
