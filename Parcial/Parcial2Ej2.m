clc, clear all, close all
convergencia =0.001;
alpha = 0.65;
syms  x y;
z =  (x - 1)^2 + (100*(y - x^2)^2);
figure
x_i = 0;  % valor inicial
y_i = 11;  % valor inicial y 
fsurf(z)
grad_z = gradient(z, [x,y]); % gradiente
hess = hessian(z,[x,y]); % hessiana

grad_x_y = subs(grad_z, [x, y], [x_i, y_i])
normal2 = double(norm (double(grad_x_y),2));
z_cord = double(subs(z, [x, y], [x_i, y_i]));

hold on;
plot3(x_i, y_i, z_cord, 'ro', 'MarkerSize', 10); 
text(x_i, y_i, z_cord+10, 'Punto Inicial', 'FontSize', 12, 'HorizontalAlignment', 'left','Color', 'white');

hold off;

cont=1;

while normal2 > convergencia

    cont=cont+1;
    grad_z_xi = double(subs(grad_z, [x, y], [x_i, y_i]));
    hess_z_zi = double(subs(hess, [x, y], [x_i, y_i]));
    in_hess = inv(hess_z_zi);
    
    newdata = [x_i,y_i] - (alpha * in_hess * grad_z_xi);
    
    grad_x_y = subs(grad_z, [x, y], [newdata(1), newdata(2)]);
    normal2 = double(norm(double(grad_x_y), 2));
    disp(normal2)
    x_i = newdata(1);
    y_i = newdata(2);
    z_cord = double(subs(z, [x, y], [x_i, y_i]));
    hold on;
    plot3(x_i, y_i, z_cord, 'ro', 'MarkerSize', 10);
    

    hold off;

end
    hold on;
    z_cord = double(subs(z, [x, y], [x_i, y_i]));

    plot3(x_i, y_i, z_cord, 'ow', 'MarkerSize', 10, 'LineWidth', 2);


    text(x_i, y_i, z_cord+10000, 'Punto final', 'FontSize', 12, 'HorizontalAlignment', 'left',  'Color', 'white');

    hold off;
title('x vs y vs z');
xlabel(' X');
ylabel(' Y');
zlabel(' Z');

disp('Resultado final:');
disp(['x: ', num2str(x_i)]);
disp(['y: ', num2str(y_i)]);
disp(['z: ', num2str(z_cord)]);
disp(['pasos: ', num2str(cont)]);
