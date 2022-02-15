 function dataset = generate_dataset_NS(param, N_samples, name)

     Tmax = param.T;
     Umin = min(param.u_min);
     Umax = max(param.u_max);
         
     switch name
         
         case 'Fourier'
             
             N_basis = 10;
             basis = {@(t) sin(2*pi*t),@(t) sin(2*pi*2*t),@(t) sin(2*pi*3*t),@(t) sin(2*pi*4*t),@(t) sin(2*pi*5*t),...
                      @(t) cos(2*pi*t),@(t) cos(2*pi*2*t),@(t) cos(2*pi*3*t),@(t) cos(2*pi*4*t),@(t) cos(2*pi*5*t)};
             %This version is for Tmax=1. Use 2*pi/Tmax if T change (change it manually)     
             
             for iTests = 1:N_samples
                 
                 dataset{iTests}.tt = [0 Tmax];
                 
                 coeff1 = (Umax-0)/(2*N_basis)*rand(1, N_basis);
                 coeff2 = (Umax-Umin)/(2*N_basis)*rand(1, N_basis);
                 
                 fstrLong = cell(1,2);
                 
                 basis_aux1 = @(t) coeff1(1)*sin(2*pi*t) + coeff1(2)*sin(2*pi*2*t) + coeff1(3)*sin(2*pi*3*t) + coeff1(4)*sin(2*pi*4*t) + coeff1(5)*sin(2*pi*5*t)+...
                              coeff1(6)*cos(2*pi*t) + coeff1(7)*cos(2*pi*2*t) + coeff1(8)*cos(2*pi*3*t) + coeff1(9)*cos(2*pi*4*t) + coeff1(10)*cos(2*pi*5*t);
                 basis_aux2 = @(t) coeff2(1)*sin(2*pi*t) + coeff2(2)*sin(2*pi*2*t) + coeff2(3)*sin(2*pi*3*t) + coeff2(4)*sin(2*pi*4*t) + coeff2(5)*sin(2*pi*5*t)+...
                              coeff2(6)*cos(2*pi*t) + coeff2(7)*cos(2*pi*2*t) + coeff2(8)*cos(2*pi*3*t) + coeff2(9)*cos(2*pi*4*t) + coeff2(10)*cos(2*pi*5*t);
                
                 maxcoeff1 = max(basis_aux1(0:0.01:Tmax));
                 maxcoeff2 = max(basis_aux2(0:0.01:Tmax));    
                   
                 shift1 = (0+maxcoeff1) + (Umax-0-2*maxcoeff1)*rand(1);
                 shift2 = (Umin+maxcoeff2) + (Umax-Umin-2*maxcoeff2)*rand(1);     
                
                 fStr1 = cellfun(@(f,c) strrep(func2str(f),'@(t)',...
                            sprintf('%.5g*',c)),basis,num2cell(coeff1),'UniformOutput',false);  
                 fStr2 = cellfun(@(f,c) strrep(func2str(f),'@(t)',...
                            sprintf('%.5g*',c)),basis,num2cell(coeff2),'UniformOutput',false);     
                     
                 fstrLong{1} = strjoin(fStr1,' + ');
                 fstrLong{1} = strcat(fstrLong{1}, ' + ', num2str(shift1));
                 fstrLong{2} = strjoin(fStr2,' + ');
                 fstrLong{2} = strcat(fstrLong{2}, ' + ', num2str(shift2));   
                              
                 u1 = @(t) 10 + (1000-10).*rand(1) + 0.*t;
                 u2 = str2func(['@(t)',fstrLong{1}]);
                 u3 = str2func(['@(t)',fstrLong{2}]);
                                 
                 dataset{iTests}.uu = @(t) [u1(t); u2(t); u3(t)];
                 
             end
             
             
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%             

         case 'Polynomial'
             
             N_basis = 5;
             basis = {@(t) t,@(t) t.^2,@(t) t.^3,@(t) t.^4,@(t) t.^5};
                       
                       
             for iTests = 1:N_samples
                 
                 dataset{iTests}.tt = [0 Tmax];
                 
                 TT = Tmax.^(-1:-1:-N_basis);
                 coeff1 = (Umax-0)/N_basis*rand(1, N_basis).*TT;
                 coeff2 = (Umax-Umin)/N_basis*rand(1, N_basis).*TT;
                 fstrLong = cell(1,2);
                                  
                 basis_aux1 = @(t) coeff1(1)*t + coeff1(2)*t.^2 + coeff1(3)*t.^3 + coeff1(4)*t.^4 + coeff1(5)*t.^5;
                 basis_aux2 = @(t) coeff2(1)*t + coeff2(2)*t.^2 + coeff2(3)*t.^3 + coeff2(4)*t.^4 + coeff2(5)*t.^5;
             
                 maxcoeff1 = max(basis_aux1(0:0.01:Tmax));
                 maxcoeff2 = max(basis_aux2(0:0.01:Tmax));                                   
                     
                 shift1 = 0 + (Umax - maxcoeff1 - 0)*rand(1);
                 shift2 = Umin + (Umax - maxcoeff2 - Umin)*rand(1);    
                 
                 fStr1 = cellfun(@(f,c) strrep(func2str(f),'@(t)',...
                            sprintf('%.5g*',c)),basis,num2cell(coeff1),'UniformOutput',false);  
                 fStr2 = cellfun(@(f,c) strrep(func2str(f),'@(t)',...
                            sprintf('%.5g*',c)),basis,num2cell(coeff2),'UniformOutput',false);      
                 
                 fstrLong{1} = strjoin(fStr1,' + ');
                 fstrLong{1} = strcat(fstrLong{1}, ' + ', num2str(shift1));
                 fstrLong{2} = strjoin(fStr2,' + ');
                 fstrLong{2} = strcat(fstrLong{2}, ' + ', num2str(shift2));   
                 
                 
                 u1 = @(t) 10 + (1000-10).*rand(1) + 0.*t;
                 u2 = str2func(['@(t)',fstrLong{1}]);
                 u3 = str2func(['@(t)',fstrLong{2}]);
                                                                    
                 dataset{iTests}.uu = @(t) [u1(t); u2(t); u3(t)];
                 
             end
     
         
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%             

         case 'Jumps'
             
               for iTests = 1:N_samples
                 
                 dataset{iTests}.tt = [0 Tmax];                
                 
                 u1 = @(t) 10 + (1000-10).*rand(1) + 0.*t;
                 time_jump = 0 + (Tmax-0.1-0).*rand(1);
                 u2 = @(t) (200 + (Umax-200).*rand(1)) + 0.*t;
                 u3 = @(t) (Umin + (Umax-Umin).*rand(1))*(t >= time_jump) + 0.*t;
                                                                    
                 dataset{iTests}.uu = @(t) [u1(t); u2(t); u3(t)];
                 
               end
     end
     end
         

