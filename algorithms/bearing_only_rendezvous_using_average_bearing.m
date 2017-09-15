function [dxi,stop_condition,energy] = bearing_only_rendezvous_using_average_bearing(L,xi)

global N desired_distance error_bearing;

dxi = zeros(2, N);
stop_condition = 1;
vmax = 1;
energy = 0;

for i = 1:N
    neighbors = topological_neighbors(L, i);
    alpha_ij = zeros(1,length(neighbors)); 
    k =1;
    % Iterate through agent i's neighbors
    for j = neighbors
        alpha_ij(k) = atan2(xi(2,j)-xi(2,i),xi(1,j)-xi(1,i)) + error_bearing*randn ;
        k=k+1;
        % For each neighbor, calculate appropriate consensus term and
        %add it to the total velocity
        %dxi(:, i) = dxi(:, i) + (xi(:, j) - xi(:, i));
        p_ij = norm(xi(1:2, i) - xi(1:2, j)) ;
        energy = energy + p_ij;
        if (p_ij > desired_distance)
            stop_condition = 0;
        end
    end
    mean_alpha = atan2(mean(sin(alpha_ij)),mean(cos(alpha_ij))); % Calcuating angular mean value

    if(~isempty(neighbors))
        dxi(1,i) = 0.5 * vmax * cos(mean_alpha) ;
        dxi(2,i) = 0.5 * vmax * sin(mean_alpha) ;
    end
    
end