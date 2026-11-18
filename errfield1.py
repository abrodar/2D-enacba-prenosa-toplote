import numpy as np
from matplotlib import pyplot
from matplotlib.ticker import MaxNLocator

T = np.loadtxt('T_test1.data')

x = np.linspace(0, 1, T.shape[1])
y = np.linspace(0, 1, T.shape[0])

X, Y = np.meshgrid(x, y)

exact = 100 * (1 - X / 1) # double check correctness!

err = T - exact

lim = np.max(np.abs(err))

levels = np.linspace(-lim, lim, 41) 

pyplot.contourf(X, Y, err, levels = levels, cmap='RdBu_r')

cbar = pyplot.colorbar()
cbar.set_label(r'$T_{num} - T_{exact}$ [℃]')
cbar.locator = MaxNLocator(7)
cbar.update_ticks()

pyplot.title('Testni primer 1, 20 x 20')
pyplot.xlabel('x')
pyplot.ylabel('y')
pyplot.gca().set_aspect('equal')
pyplot.savefig('testcase1_errfield_20x20.png', dpi = 200, bbox_inches = 'tight')
pyplot.show()

