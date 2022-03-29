import matplotlib.pyplot as plt

size = [4, 6, 8, 10, 12, 14, 16]
time = [0.052, 0.18781, 0.65593, 1.68555, 3.52416, 8.66517, 15.93044]
it = [2.0, 2.0, 2.2, 2.2, 2.1, 2.2, 2.2]
ddpmv = [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0]
had_enough_time = [10, 10, 10, 10, 10, 10, 10]

fig, ax1 = plt.subplots()

color = 'tab:red'
ax1.set_xlabel("size")
ax1.set_ylabel('time (s)', color=color)
ax1.plot(size, time, color=color)
ax1.tick_params(axis='y', labelcolor=color)

ax2 = ax1.twinx()  # instantiate a second axes that shares the same x-axis

color = 'tab:blue'
ax2.set_ylabel('Dinkelbach iterations', color=color)  # we already handled the x-label with ax1
ax2.plot(size, it, color=color)
ax2.tick_params(axis='y', labelcolor=color)

fig.tight_layout()  # otherwise the right y-label is slightly clipped
plt.show()