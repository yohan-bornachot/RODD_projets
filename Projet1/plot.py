import matplotlib.pyplot as plt

sizes = [5, 10, 15, 20, 25, 30, 35, 40, 45, 50]
times = [0.0067, 0.0489, 0.1191, 0.1409, 0.3595, 0.3797, 0.9685, 2.2294, 8.9726, 6.2267]
objectives = [62.5, 66.5, 54.3, 53.7, 54.2, 44.7, 46.8, 43.2, 45.2, 40.4]
feasible_instances_prop = [0.10101010101010101, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0]

fig, ax1 = plt.subplots()

color = 'tab:red'
ax1.set_xlabel("size")
ax1.set_ylabel('time (s)', color=color)
ax1.plot(sizes, times, color=color)
ax1.tick_params(axis='y', labelcolor=color)

ax2 = ax1.twinx()  # instantiate a second axes that shares the same x-axis

color = 'tab:blue'
ax2.set_ylabel('objective', color=color)  # we already handled the x-label with ax1
ax2.plot(sizes, objectives, color=color)
ax2.tick_params(axis='y', labelcolor=color)

fig.tight_layout()  # otherwise the right y-label is slightly clipped
plt.show()


nb_species = [2, 6, 10, 14, 18, 22, 26, 30, 34, 38]
times = [0.016, 0.061, 0.1076, 0.1078, 0.1297, 0.1402, 0.1872, 0.1519, 0.6244, 1.2448]
objectives = [35.3, 64.5, 82.9, 97.3, 116.6, 118.7, 127.5, 135.7, 138.7, 139.4]
feasible_instances_prop = [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0]

fig, ax1 = plt.subplots()

color = 'tab:red'
ax1.set_xlabel("nb_species")
ax1.set_ylabel('time (s)', color=color)
ax1.plot(nb_species, times, color=color)
ax1.tick_params(axis='y', labelcolor=color)

ax2 = ax1.twinx()  # instantiate a second axes that shares the same x-axis

color = 'tab:blue'
ax2.set_ylabel('objective', color=color)  # we already handled the x-label with ax1
ax2.plot(nb_species, objectives, color=color)
ax2.tick_params(axis='y', labelcolor=color)

fig.tight_layout()  # otherwise the right y-label is slightly clipped
plt.show()
