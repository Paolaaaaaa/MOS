"""
Calculo de frente de pareto (metodo econtraints) de dos funciones objetivo

"""

#Plot Imports
import matplotlib.pyplot as plt

from pyomo.opt import SolverFactory
from pyomo.environ import *


# Creación del Modelo 
#Creaci�n Modelo--------------------------------------------------------------
Model = ConcreteModel()

#sets & parameters------------------------------------------------------------
numNodes = 5
Model.N=RangeSet(1,numNodes)

#hops-----------------------------------------------------------------------
Model.h =Param(Model.N, Model.N, mutable=True)

for i in Model.N:
    for j in Model.N:
        Model.h[i,j] = 999


Model.h[1,2] = 1
Model.h[1,3] = 1
Model.h[2,5] = 1
Model.h[3,4] = 1
Model.h[4,5] = 1

#costos-----------------------------------------------------------------------
Model.c =Param(Model.N, Model.N, mutable=True)

for i in Model.N:
    for j in Model.N:
        Model.c[i,j] = 999

Model.c[1,2] = 10
Model.c[1,3] = 5
Model.c[2,5] = 10
Model.c[3,4] = 5
Model.c[4,5] = 5
#origen y destino-----------------------------------------------------------------------

inicial = 1
destino = 5

#Variable de desición

Model.x = Var(Model.N,Model.N, domain=Binary)

#función dee esaltas
Model.f1 = sum(Model.x[i,j] * Model.h[i,j] for i in Model.N for j in Model.N)

#función de costos
Model.f2 = sum(Model.x[i,j] * Model.c[i,j] for i in Model.N for j in Model.N)




def delete_component(Model, comp_name):

        list_del = [vr for vr in vars(Model)
                    if comp_name == vr
                    or vr.startswith(comp_name + '_index')
                    or vr.startswith(comp_name + '_domain')]

        list_del_str = ', '.join(list_del)
        print('Deleting model components ({}).'.format(list_del_str))

        for kk in list_del:
            Model.del_component(kk)
#restricción nodos intermedios



f1_vals =[]
f2_vals = []
for k in range(0,(numNodes*numNodes)):
        

        # Función

        Model.z = Objective(expr=Model.f2, sense=minimize)

        #Source node restriccion
        def restriccion1(Model, i ):
            if i ==inicial:
                return sum(Model.x[i,j] for j in Model.N ) == 1
            else:
                return Constraint.Skip

        # nodo final restricción
        def restriccion2(Model, i ):
            if i ==destino:
                return sum(Model.x[j,i] for j in Model.N ) == 1
            else:
                return Constraint.Skip
            
        def restriccion3(Model, i ):
            if i !=destino and i !=inicial:
                return sum(Model.x[i,j] for j in Model.N)== sum(Model.x[j,i] for j in Model.N)
            else:
                return Constraint.Skip

        def restriccion4(Model, i):
            return Model.f1 <= k
        
        Model.res1=Constraint(Model.N, rule=restriccion1)
        Model.res2=Constraint(Model.N, rule=restriccion2)
        Model.res3=Constraint(Model.N, rule=restriccion3)
        Model.res4=Constraint(Model.N,rule=restriccion4)
        SolverFactory('glpk').solve(Model)
        try: 


            valorF1=value(Model.f1)
            valorF2=value(Model.f2)
            f1_vals.append(valorF1)
            f2_vals.append(valorF2)
        except:
            pass

        delete_component(Model, 'z')
        delete_component(Model, 'res1')
        delete_component(Model, 'res2')
        delete_component(Model, 'res3')
        delete_component(Model, 'res4')



print(f1_vals)
print(f2_vals)
plt.plot(f1_vals,f2_vals,'o-.');
plt.title('Frente optimo de Pareto');
plt.xlabel('F1')
plt.ylabel('F2')

plt.grid(True);
plt.show()

