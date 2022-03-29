import matplotlib.pyplot as plt

# Plot influence du nombre d'alleles
nb_alleles = [2, 3, 4, 5, 6, 7, 8, 9]
time = [0.036, 0.065, 0.076, 0.086, 0.1, 0.1, 0.098, 0.095]
obj = [0.0, 0.05482, 1.24986, 2.87151, 6.3024, 10.94365, 17.23793, 22.08591]

fig, ax1 = plt.subplots()
color = 'tab:red'
ax1.set_xlabel("Nb d'allèles")
ax1.set_ylabel('time (s)', color=color)
ax1.plot(nb_alleles, time, color=color)
ax1.tick_params(axis='y', labelcolor=color)
ax2 = ax1.twinx()  # instantiate a second axes that shares the same x-axis
color = 'tab:blue'
ax2.set_ylabel('Objectif', color=color)  # we already handled the x-label with ax1
ax2.plot(nb_alleles, obj, color=color)
ax2.tick_params(axis='y', labelcolor=color)
fig.tight_layout()  # otherwise the right y-label is slightly clipped
plt.show()

# Plot pour l'influence du nombre de gènes
nb_genes = [15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110]
time = [0.049, 0.057, 0.088, 0.123, 0.154, 0.162, 0.17, 0.25, 0.242, 0.327, 0.321, 0.532, 0.651, 0.659, 0.66, 0.616, 0.78, 0.706, 0.799, 0.989]
obj = [0.0, 0.0, 0.0, 0.0, 0.0002, 0.00063, 0.00191, 0.0, 0.00021, 6.0e-5, 3.0e-5, 0.00023, 0.00082, 0.00085, 0.00109, 0.0002, 0.00059, 0.00014, 0.00095, 0.002]

fig, ax1 = plt.subplots()
color = 'tab:red'
ax1.set_xlabel("Nb gènes")
ax1.set_ylabel('time (s)', color=color)
ax1.plot(nb_genes, time, color=color)
ax1.tick_params(axis='y', labelcolor=color)
ax2 = ax1.twinx()  # instantiate a second axes that shares the same x-axis
color = 'tab:blue'
ax2.set_ylabel('Objectif', color=color)  # we already handled the x-label with ax1
ax2.plot(nb_genes, obj, color=color)
ax2.tick_params(axis='y', labelcolor=color)
fig.tight_layout()  # otherwise the right y-label is slightly clipped
plt.show()

# Plot pour l'influence du nombre d'individu
nb_indivs = [6, 12, 18, 24, 30, 36, 42, 48]
time = [0.051, 0.047, 0.042, 0.053, 0.058, 0.066, 0.068, 0.068]
obj = [0.03652, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]

fig, ax1 = plt.subplots()
color = 'tab:red'
ax1.set_xlabel("Nb individus")
ax1.set_ylabel('time (s)', color=color)
ax1.plot(nb_indivs, time, color=color)
ax1.tick_params(axis='y', labelcolor=color)
ax2 = ax1.twinx()  # instantiate a second axes that shares the same x-axis
color = 'tab:blue'
ax2.set_ylabel('Objectif', color=color)  # we already handled the x-label with ax1
ax2.plot(nb_indivs, obj, color=color)
ax2.tick_params(axis='y', labelcolor=color)
fig.tight_layout()  # otherwise the right y-label is slightly clipped
plt.show()

# Plot pour l'influence du nombre de morceaux pour l'approximation du log
thetas = [10, 30, 50, 70, 90, 110]
time = [0.04, 0.063, 0.095, 0.123, 0.142, 0.191]
obj = [0.77491, 0.79327, 0.7946, 0.79496, 0.7951, 0.79517]

fig, ax1 = plt.subplots()
color = 'tab:red'
ax1.set_xlabel("Nb de morceaux")
ax1.set_ylabel('time (s)', color=color)
ax1.plot(thetas, time, color=color)
ax1.tick_params(axis='y', labelcolor=color)
ax2 = ax1.twinx()  # instantiate a second axes that shares the same x-axis
color = 'tab:blue'
ax2.set_ylabel('Objectif', color=color)  # we already handled the x-label with ax1
ax2.plot(thetas, obj, color=color)
ax2.tick_params(axis='y', labelcolor=color)
fig.tight_layout()  # otherwise the right y-label is slightly clipped
plt.show()