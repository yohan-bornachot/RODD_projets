import matplotlib.pyplot as plt

N = [10, 15, 20, 25, 30, 35, 40, 45, 50, 55]
time1 = [0.0159, 0.0207, 0.0329, 0.0434, 0.0702, 0.1028, 0.1241, 0.1685, 0.2161, 0.3203]
obj1 = [7843.8, 17709.0, 31471.1, 49151.2, 70788.3, 96292.3, 125766.9, 159398.9, 196683.8, 237689.7]

fig, ax1 = plt.subplots()
color = 'tab:red'
ax1.set_xlabel("Taille de l'instance")
ax1.set_ylabel('time (s)', color=color)
ax1.plot(N, time1, color=color)
ax1.tick_params(axis='y', labelcolor=color)
ax2 = ax1.twinx()  # instantiate a second axes that shares the same x-axis
color = 'tab:blue'
ax2.set_ylabel('Objectif', color=color)  # we already handled the x-label with ax1
ax2.plot(N, obj1, color=color)
ax2.tick_params(axis='y', labelcolor=color)
fig.tight_layout()  # otherwise the right y-label is slightly clipped
plt.show()

time2 = [0.0121, 0.0202, 0.03, 0.0462, 0.0725, 0.1091, 0.1557, 0.2181, 0.3097, 0.4105]
obj2 = [7843.8, 17709.0, 31471.1, 49151.2, 70788.3, 96292.3, 125766.9, 159398.9, 196683.8, 237689.7]

fig, ax1 = plt.subplots()
color = 'tab:red'
ax1.set_xlabel("Taille de l'instance")
ax1.set_ylabel('time (s)', color=color)
ax1.plot(N, time2, color=color)
ax1.tick_params(axis='y', labelcolor=color)
ax2 = ax1.twinx()  # instantiate a second axes that shares the same x-axis
color = 'tab:blue'
ax2.set_ylabel('Objectif', color=color)  # we already handled the x-label with ax1
ax2.plot(N, obj2, color=color)
ax2.tick_params(axis='y', labelcolor=color)
fig.tight_layout()  # otherwise the right y-label is slightly clipped
plt.show()