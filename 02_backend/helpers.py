from datetime import datetime
import matplotlib.pyplot as plt
import numpy as np


def date_to_str(date):
    return str(date).replace(' ', 'T')


def calc_available_cars(offers):
    count = 0
    if len(offers.keys()) > 2:
        # error in station (e.g. closed)
        return 0

    for offer in offers['offers']:
        status = offer['status']
        if status == 'available':
            count += 1
        else:
            print(f"Not available, status={status}")
    return count


def calc_station_list(stations):
    station_list = []
    for station in stations:
        station_list.append(station['id'])
    return station_list


def plot_offer_list(offer_mat):
    fig = plt.figure()
    plt.plot(offer_mat)
    # for i in range(offer_mat.shape[1]):
    #     plt.plot(offer_mat[:, i], legend=f'day {i+1}')
    plt.title('Available cars at Sixt Car for the next week in Munich')
    dates = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
    date_ticks = np.arange(0, len(offer_mat), int(len(offer_mat)/7))
    date_ticks += 1
    plt.xticks(date_ticks, dates)
    plt.show()
