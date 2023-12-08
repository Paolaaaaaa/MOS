"""



Avance: Por ahora solo minimiza el número de paradas
"""
from __future__ import division

from pyomo.environ import *

from pyomo.opt import SolverFactory
import matplotlib.pyplot as plt



Model = ConcreteModel()

inicial = 1
final =6
ruta = 11

costoViaje_max =7
estaciones =15
alpha= 0.1
beta=0.1
epsilon=0.8
N= RangeSet(1,estaciones)
R= RangeSet(1,ruta)


Model.routes = Param(N, N,R,mutable=True)

Model.costo = Param(N, N,R,mutable=True)

for i in N:
    for j in N:
        for k in R:
            Model.routes[i,j,k]=9999


for i in N:
    for j in N:
        for k in R:
            Model.costo[i,j,k]=0


data_cost={


    (11,6,11):3,
    (4,8,8):3



      
            
}


data={
    (10,7,1):1,(7,5,1):1,(5,3,1):1,
    (10,8,2):1,(8,4,1):1,(4,3,1):1, 
    (10,9,3):1,
    (10,9,4):1,(9,8,4):1, (8,7,4):1,(7,6,4):1, (6,5,4):1,(5,4,4):1,(4,3,4):1,  
    (3,4,5):1,(4,7,5):1, (7,8,5):1,(8,10,5):1, 
    (3,5,6):1,(5,7,6):1, (7,10,6):1, 
    (10,8,7):1,(8,7,7):1, (7,4,7):1,(4,3,7):1, 
    (3,4,8):1,(4,8,8):1, (8,10,8):1,
    (3,4,9):1,(4,5,9):1, (5,4,9):1,(5,6,9):1, (6,7,9):1, (7,8,9):1,(9,10,9):1,
    (1,14,10):1,(14,2,10):1,(2,12,10):1, (12,13,10):1, (13,15,10):1,(15,7,10):1,
    (1,14,11):1,(14,11,11):1, (11,6,11):1

      
            
}


for key, value in data.items():
    Model.routes[key].set_value(value)

for key, value in data_cost.items():
     Model.costo[key].set_value(value)
# VARIABLES****************************************************************************

Model.x = Var(N,N,R, domain=Binary)
Model.y = Var(R, domain=Binary)

# OBJECTIVE FUNCTION*******************************************************************
#
Model.obj = Objective(expr = alpha * sum(Model.x[i,j,k] * Model.routes[i,j,k] for i in N for j in N for k in R) 
                      + beta*sum (Model.y[k]  for k in R)
                      + epsilon *(3+sum(Model.x[i,j,k]* Model.routes[i,j,k] * Model.costo[i,j,k] for i in N for j in N for k in R)))
# CONSTRAINTS**************************************************************************
#La suma de todos los nodos iniciales debe ser igual a 1
def restriccion1(Model, i ):
    if i ==inicial:
        return sum(Model.x[i,j,k] for j in N for k in R) == 1
    else:
        return Constraint.Skip
Model.res1=Constraint(N, rule=restriccion1)

#la suma del nodo de llegada debe ser igual a 1
def restriccion2(Model, i ):
    if i ==final:
        return sum(Model.x[j,i, k] for j in N for k in R) == 1
    else:
        return Constraint.Skip
Model.res2=Constraint(N, rule=restriccion2)


def restriccion3(Model, i ):
    if i !=final and i !=inicial:
        return sum(Model.x[i,j,k] for j in N for k in R)== sum(Model.x[j,i, k] for j in N for k in R)
    else:
        return Constraint.Skip

Model.res3=Constraint(N, rule=restriccion3)



def restriccion4(Model, i,j,k ):
   return Model.y[k] >=(Model.x[i,j, k] * Model.routes[i,j,k] )
Model.res4=Constraint(N,N,R, rule=restriccion4)

# Costo maximo del viaje
def restriccion5(Model, i ):
   return sum(Model.x[i,j,k] * Model.costo[i,j,k] for i in N for j in N for k in R)+3<=costoViaje_max
Model.res5=Constraint(R, rule=restriccion5)





#Solve
SolverFactory('glpk').solve(Model)
Model.display()


coordenadas = {
    1: [0, 0],
    2: [5, 0],
    3: [1, 4],
    4: [2, 4],
    5: [3, 4],
    6: [4, 4],
    7: [5, 4],
    8: [6, 4],
    9: [7, 4],
    10: [9, 4],
    11: [4, 0],
    12: [6, 0],
    13: [7, 0],
    14: [2, 0],
    15: [8, 0]
}



## Graph

def generar_color(k):
    red = (k * 80) % 256 
    green = (k * 50) % 256  
    blue = (k * 70) % 256  
    return (red/255, green/255, blue/255) 

x =[]
y=[]
k=[]
for key, value in data.items():
    x.append(key[0])#Nodo inicio
    y.append(key[1])#nodo fin
    k.append(key[2])#ruta

            
figure_1 = plt.figure(figsize=(20, 20))
ax_1 = figure_1.add_subplot(1,1,1)


for i in range(0,len(x)):
            
            lines_x=[coordenadas[x[i]][0],coordenadas[y[i]][0]]
            lines_y=[coordenadas[x[i]][1],coordenadas[y[i]][1]]
            colors=generar_color(k[i])
            

            ax_1.plot(lines_x,lines_y,"--", color=colors,marker='o')

j_to_remember =0
for i in N:
    for j in N:
        for k in R:
            distancia =  Model.x[i,j, k].value
            if distancia==1:
                            
                lines_x=[coordenadas[i][0],coordenadas[j][0]]
                lines_y=[coordenadas[i][1],coordenadas[j][1]]
                ax_1.plot(lines_x,lines_y,color="red",marker='o')
                ax_1.text(coordenadas[j][0]-0.1,coordenadas[j][1]+0.1,"Estación: "+str(j)+" ruta: "+ str(k), size=10 )
                j_to_remember= j


                

ax_1.text(coordenadas[inicial][0]-0.1,coordenadas[inicial][1]+0.1,"Estación"+str(inicial)+":Inicio", size=10 )

ax_1.text(coordenadas[final][0]-0.1,coordenadas[final][1]+0.3,"Estación"+str(final)+":Destino", size=10 )

            



ax_1.set_xlabel('x')
ax_1.set_ylabel('y')




costo_viaje = (3+sum(Model.x[i,j,k].value* Model.routes[i,j,k].value * Model.costo[i,j,k].value for i in N for j in N for k in R))
print(costo_viaje)
calc_transbordos = sum (Model.y[k].value  for k in R)
paradas = sum(Model.x[i,j,k].value for i in N for j in N for k in R) 
titulo =" y vs x. Costo total: "+str(costo_viaje) +", Numero total de transbordos: "+str(calc_transbordos-1)+", Numero de paradas: "+str(paradas)
ax_1.set_title(titulo)
plt.show()
