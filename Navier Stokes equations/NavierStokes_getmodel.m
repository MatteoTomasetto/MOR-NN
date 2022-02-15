function model = NavierStokes_getmodel(problem)

    fprintf('building NS model (blackbox version)...')
    
    % assign the problem struct to the model struct
    model.problem = problem;
    model.blackbox = 1;
    model.forward_function = @forward_function;
    dt = 0.05; 
    model.dt = dt;
   
    fprintf(' done!\n')
    
    fprintf('   - loading mesh... ')
    mesh = read_mesh('cylinder.msh');
    fprintf(' done!\n')
    L = mesh.L; % Lunghezza canale
      
    bc_flags = [1 0 1];   % 1 = Dirichlet   0 = Neumann 

    fprintf('   - building fespaces... ')
    fespace_x = create_fespace(mesh,'P2',bc_flags);
    fespace_p = create_fespace(mesh,'P1',bc_flags);
    fprintf('done!\n')
    
    n_nodes_x = size(fespace_x.nodes,1);
    n_nodes_p = size(fespace_p.nodes,1);
    n_tot = 2 * n_nodes_x + n_nodes_p;
    
    % vector with d.o.f. related to the cylinder
    sz = size(mesh.vertices,1);
    idx_cylinder_drag = zeros(n_tot,1);
    idx_cylinder_lift = zeros(n_tot,1);
    for i = 1:sz
        if(mesh.vertices(i,3)==3 && abs(mesh.vertices(i,2))~=2)
        idx_cylinder_drag(i,1) = 1; 
        idx_cylinder_lift(i+n_nodes_x,1) = 1; 
        end
    end
    
    
    function output = forward_function(test, options)
         
         % initialization
         tt = test.tt(1):dt:test.tt(end);
         T = problem.T;
         nT = length(tt);
         if isa(test.uu,'function_handle')
            ufunc = test.uu;
            uu = ufunc(tt);
            dirichlet_functions = @(t,x) [[0,1,0]*test.uu(t) [0,0,1]*test.uu(t);0 0;0 0]'; 
            
         else
            uu = interp_time_series(test.tt,test.uu,tt);
            uu(1,:) = 10 + (1000-10).*rand(1); 
            uu(2,:) = abs(uu(2,:));
            dirichlet_functions = @(t,x) [((uu(2,2:nT) - uu(2,1:(nT-1))).*(t-tt(1:(nT-1)))./(tt(2:nT)-tt(1:(nT-1))) + uu(2,1:(nT-1)))*((tt(1:(nT-1))<t).*(t<=tt(2:nT)))', ((uu(3,2:nT) - uu(3,1:(nT-1))).*(t-tt(1:(nT-1)))./(tt(2:nT)-tt(1:(nT-1))) + uu(3,1:(nT-1)))*((tt(1:(nT-1))<t).*(t<=tt(2:nT)))';0 0;0 0]';              
         
         end
                 
         Reynolds = uu(1,1); 
         mu = L*(0.5*problem.u_max(1)-0.5*problem.u_min(1))/Reynolds;
         f = @(t,x) [0;0];
         neumann_functions = @(t,x) [0 0; 0 0; 0 0]';
         yy = zeros(problem.nY,nT);
         vecsol = zeros(n_tot, 1);  
 
        for iT = 2:length(tt) 
             
             [A,B,b] = assembler_unsteady_stokes(fespace_x,fespace_p,@(x) f(tt(iT),x),mu,@(x) dirichlet_functions(tt(iT),x),@(x) neumann_functions(tt(iT),x),dt);
             [A_no_bc,B_no_bc,b_no_bc] = assembler_unsteady_stokes_no_bc(fespace_x,fespace_p,@(x) f(tt(iT),x),mu,dt);
         
             fprintf('iter %d\n',iT)
             fprintf('   Solving linear system... ')
             x = vecsol(1:2*n_nodes_x);
             A_C = add_convective_term(A,x,fespace_x);
             A_C_no_bc = add_convective_term_no_bc(A_no_bc,x,fespace_x);
             
             vecsol = A_C \ (B*vecsol + b);
             fprintf('done!\n')
             
             %  Plot of the velocity
             %close all
             %figure(1);
             %indices_x1 = 1:n_nodes_x;
             %indices_x2 = n_nodes_x+1:2*n_nodes_x;
             %indices_p = 2*n_nodes_x+1:2*n_nodes_x+n_nodes_p;
             %sol.n_nodes_u = n_nodes_x;
             %sol.n_nodes_p = n_nodes_p;
             %sol.u1 = vecsol(indices_x1);
             %sol.u2 = vecsol(indices_x2);
             %sol.p = vecsol(indices_p);
             %sol.fespace_u = fespace_x;
             %sol.fespace_p = fespace_p;
             %plot_fe_fluid_function(sol,'U');
             %pause(1e-8);
             
             % Output definition: to find the indexes for nodes on the cylinder see mesh.vertices
             residual = A_C_no_bc*vecsol - (B*vecsol+ b);
             Vin = uu(2,iT)^2+uu(3,iT)^2;
             const_norm = 0.5*Vin;
             
             yy(1,iT) = -residual'*idx_cylinder_drag/const_norm;  % Resistence/Drag coefficient
             yy(2,iT) = residual'*idx_cylinder_lift/const_norm;  % Lift coefficient
                      
        end
                     
        output.tt = tt;
        output.uu = uu;
        output.yy = yy;
end

function make_plot(vecsol,opt)
        
        opt.dummy = 0;
        if ~isfield(opt,'new_figure')
            opt.new_figure = 0;
        end
        
        if opt.new_figure
            figure('units','normalized','outerposition',[0 0 .3 .6]);
        end
        
         n_nodes_x = size(fespace_x.nodes,1);
         n_nodes_p = size(fespace_p.nodes,1);
         indices_x1 = 1:n_nodes_x;
         indices_x2 = n_nodes_x+1:2*n_nodes_x;
         indices_p = 2*n_nodes_x+1:2*n_nodes_x+n_nodes_p;
         sol.n_nodes_x = n_nodes_x;
         sol.n_nodes_p = n_nodes_p;
         sol.x1 = vecsol(indices_x1);
         sol.x2 = vecsol(indices_x2);
         sol.p = vecsol(indices_p);
         sol.fespace_x = fespace_x;
         sol.fespace_p = fespace_p;

        subplot(2,1,1)
        
        plot_fe_fluid_function(sol,'U');
        colorbar
        axis equal
        hold off
        subplot(2,1,2)
        plot_fe_fluid_function(sol,'P');
        colorbar
        axis equal
        hold off
end

end