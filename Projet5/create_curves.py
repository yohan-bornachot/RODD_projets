import numpy as np 
import matplotlib.pyplot as plt

with open("./result.csv","r") as f:
    data = f.readlines()
    T = int(data[0])
    cost = list(map(lambda x: float(x),data[1][1:-2].split(",")))
    pol = list(map(lambda x: float(x),data[2][1:-2].split(",")))
    pol_var = list(map(lambda x: float(x),data[3][1:-2].split(",")))

t = [i for i in range(1, T+1)]
plt.xlabel("Taille de la fenêtre glissante")
plt.legend(["Cout", "Pollution"])

fig, ax1 = plt.subplots()

color = 'tab:red'
ax1.set_xlabel('Taille de la période glissante')
ax1.set_ylabel('Coût moyen', color=color)
ax1.plot(t, cost, color=color)
ax1.tick_params(axis='y', labelcolor=color)

ax2 = ax1.twinx()  # instantiate a second axes that shares the same x-axis

color = 'tab:blue'
ax2.set_ylabel('Pollution moyenne', color=color)  # we already handled the x-label with ax1
ax2.plot(t, pol, color=color)
ax2.plot(t, pol+pol_var, color=color, s='-')
ax2.plot(t, pol-pol_var, color=color, s='-')
ax2.tick_params(axis='y', labelcolor=color)

fig.tight_layout()  # otherwise the right y-label is slightly clipped
plt.show()