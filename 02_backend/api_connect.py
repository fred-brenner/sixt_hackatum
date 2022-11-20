from http.client import HTTPSConnection
import time
import numpy as np
import json
import urllib3


def sixt_api(url_request):
    start_time = time.time()
    # Request and Receive Response
    con = urllib3.PoolManager()
    r = con.request('GET', url_request)
    byte_str = r.data
    data = json.loads(byte_str)
    end_time = time.time()
    duration = end_time - start_time

    return data, duration


def add_to_url(url, add_term):
    if url.endswith('/'):
        new_url = url + add_term
    else:
        new_url = f"{url}&{add_term}"
    return new_url
