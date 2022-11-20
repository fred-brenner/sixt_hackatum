import numpy as np
import matplotlib.pyplot as plt
from seaborn import heatmap

plt.style.use('dark_background')


def calculate_flex_fleet(share_size, flex_size, usage_hours_per_day,
                         charge_duration, full_charge_duration):
    # dates = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
    dates = list(np.arange(1, 101))

    # fixed parameters
    avg_speed = 32
    avg_tank = 800
    avg_home = 30
    limit_home = 80
    start_bat_percentage = 50
    weekend_factor = 1.25

    n_cars_charge_need = 0
    cur_tank_all = np.ones(share_size) * avg_tank * start_bat_percentage / 100
    start_mean = None

    fleet_list = []
    for date in dates:

        # if date == 'Sat' or date == 'Sun':
        if (date+1)%7 == 0 or date%7 == 0:
            usage_hour = usage_hours_per_day * weekend_factor
        else:
            usage_hour = usage_hours_per_day

        km_driven = avg_speed * usage_hour
        km_driven_all = km_driven * share_size

        # let share cares drive (during day)
        i = 0
        cur_tank_all = np.sort(cur_tank_all)
        while km_driven_all >= 0:
            driving = cur_tank_all[i] - limit_home
            if driving > km_driven_all:
                driving = km_driven_all
            km_driven_all -= driving
            cur_tank_all[i] -= driving
            i += 1

            if km_driven_all <= 0:
                break
            if i >= share_size:
                return False

        # let flex car drive and load (during night)
        cur_tank_all = np.sort(cur_tank_all)
        for i in range(flex_size):
            cur_tank_all[i] -= avg_home
            cur_tank_all[i] += (avg_tank * charge_duration / full_charge_duration)
            if cur_tank_all[i] > avg_tank:
                # reset tank to full
                cur_tank_all[i] = avg_tank

        # add tank to fleet list
        fleet_list.append(cur_tank_all)
        if start_mean is None:
            start_mean = cur_tank_all.mean()

    end_mean = cur_tank_all.mean()
    if start_mean > end_mean:
        return False
    return fleet_list


def plot_fleet_timeline(fleet_timeline, flex_size):
    mean_tank = []
    dates = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
    for fleet_day in fleet_timeline:
        mean_tank.append(fleet_day.mean())

    fig = plt.figure()
    plt.plot(mean_tank, c='orange')
    plt.title(f'Sixt Goodnight minimum fleet size: {flex_size}')
    # date_ticks = list(np.arange(0, len(mean_tank), 1))
    # plt.xticks(date_ticks, dates)
    plt.ylabel('average km available')
    plt.xlabel('days')
    plt.grid(axis='y')
    plt.show()


def plot_heatmap(fleet_timeline):
    vmax = 800
    vmin = 0
    cmap = 'Oranges'
    linewidths = 0.0
    linecolor = 'white'
    # cbar=True
    xticklabels=''
    yticklabels=''
    i = 0
    for cur_fleet in fleet_timeline:
        fig = plt.figure(i)
        # value, counts = np.unique(cur_fleet, return_counts=True)
        # data = np.asarray([unique, counts])
        mat = cur_fleet[:2916].reshape(54, 54)
        heatmap(mat, vmax=vmax, vmin=vmin, cmap=cmap,
                linewidths=linewidths, linecolor=linecolor,
                xticklabels=xticklabels, yticklabels=yticklabels)

        f_name = f"gif/heatmap_{i}.png"
        plt.savefig(f_name)
        plt.close(fig)

        i += 1


if __name__ == '__main__':
    share_size = 3000
    flex_size = 850

    usage_hours_per_day = 4

    charge_duration = 6
    high_charge_percentage = 0.8
    full_charge_duration = high_charge_percentage * 6 + (1-high_charge_percentage)*20

    fleet_timeline = calculate_flex_fleet(share_size, flex_size, usage_hours_per_day,
                                          charge_duration, full_charge_duration)
    # adjust bot until
    while fleet_timeline is False:
        flex_size += 10
        fleet_timeline = calculate_flex_fleet(share_size, flex_size, usage_hours_per_day,
                                              charge_duration, full_charge_duration)

    plot_fleet_timeline(fleet_timeline, flex_size)
    plot_heatmap(fleet_timeline)

    print("Finished")
