from http.client import HTTPSConnection
import time
import numpy as np
from api_connect import *
from helpers import *
from datetime import datetime, timedelta


url = "https://api.orange.sixt.com/v1/"


def get_location_info(location):
    loc_url = add_to_url(url, f"locations?term={location}")
    loc_url_car = add_to_url(loc_url, 'vehicleType=car')
    loc_url_truck = add_to_url(loc_url, 'vehicleType=truck')

    car_json, t = sixt_api(loc_url_car)
    truck_json, t = sixt_api(loc_url_truck)

    return car_json, truck_json


def get_offers(station, date, duration):
    # cast duration from hours to seconds
    duration *= 3600
    date_start = date_to_str(date)
    date_end = date_to_str(date + timedelta(0,duration))
    req_url = add_to_url(url, f"rentaloffers/offers?pickupStation={station}&returnStation={station}")
    req_url = add_to_url(req_url, f"pickupDate={date_start}&returnDate={date_end}")
    req_url = add_to_url(req_url, "vehicleType=car&currency=EUR&isoCountryCode=DE")

    offers, t = sixt_api(req_url)

    return offers


if __name__ == '__main__':
    stations = []
    # get available stations
    locations = ['Garching München', 'München']
    for loc in locations:
        car, truck = get_location_info(loc)
        stations.extend(calc_station_list(car))

    # specific station details
    # currently no use case

    # get available offers
    start_date = datetime.fromisoformat('2022-11-21T14:00:00')
    duration = 6  # in hours

    # start api loop
    samples = int(7 * 24 / duration)
    offer_list = []

    for n in range(samples):
        offer_list_temp = []
        for station in stations:
            # get current time
            td = n * duration * 3600
            date = start_date + timedelta(0, td)
            # get offers
            offers = get_offers(station, date, duration)
            n_offers = calc_available_cars(offers)
            offer_list_temp.append(n_offers)
        offer_list.append(sum(offer_list_temp))

    # offer_mat = np.asarray(offer_list).reshape((-1, 7))
    offer_mat = np.asarray(offer_list)
    plot_offer_list(offer_mat)

    print("Finish")
