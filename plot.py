import numpy as np
from matplotlib import pyplot

T = np.loadtxt('T_test2.data')

x = np.linspace(0, 1, T.shape[1])
y = np.linspace(0, 1, T.shape[0])
levels = np.linspace(0, 100, 51)

pyplot.contourf(x, y, T, levels = levels)
cbar = pyplot.colorbar()
cbar.set_label('Temperatura [℃]')
cbar.set_ticks(np.arange(0, 101, 10))
pyplot.title('Testni primer 2, * x *')
pyplot.xlabel('x')
pyplot.ylabel('y')
# levels 4 test case 2: [2, 4, 6, 8, 10, 20, 30, 40, 50, 60, 70, 80, 90]
lines = pyplot.contour(x, y, T, levels= [10, 20, 30, 40, 50, 60, 70, 80, 90], colors='black', linewidths=0.5)
pyplot.clabel(lines, fontsize = 7)
pyplot.gca().set_aspect('equal')
pyplot.savefig('T_test2_contour.png', dpi=200, bbox_inches='tight')
pyplot.show()
