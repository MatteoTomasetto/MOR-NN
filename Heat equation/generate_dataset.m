 function dataset = generate_dataset(param, N_samples, name)

     Tmax = param.T;
     Umin = min(param.u_min);
     Umax = max(param.u_max);
     dimU = param.nU;
     
     switch name
         
         case 'Fourier'
             
             N_basis = 10;
             basis = {@(t) sin(2*pi*t),@(t) sin(2*pi*2*t),@(t) sin(2*pi*3*t),@(t) sin(2*pi*4*t),@(t) sin(2*pi*5*t),...
                      @(t) cos(2*pi*t),@(t) cos(2*pi*2*t),@(t) cos(2*pi*3*t),@(t) cos(2*pi*4*t),@(t) cos(2*pi*5*t)};
             %This version is for Tmax=1. Use 2*pi/Tmax if T change (change it manually)     
             
             for iTests = 1:N_samples
                 
                 dataset{iTests}.tt = [0 Tmax];
                 
                 coeff = (Umax-Umin)/(2*N_basis)*rand(dimU, N_basis);
                 
                 fstrLong = cell(1,dimU);
                 u = cell(1,dimU);
                 
                 for i = 1:dimU
                     
                     basis_aux = @(t) coeff(i,1)*sin(2*pi*t) + coeff(i,2)*sin(2*pi*2*t) + coeff(i,3)*sin(2*pi*3*t) + coeff(i,4)*sin(2*pi*4*t) + coeff(i,5)*sin(2*pi*5*t)+...
                              coeff(i,6)*cos(2*pi*t) + coeff(i,7)*cos(2*pi*2*t) + coeff(i,8)*cos(2*pi*3*t) + coeff(i,9)*cos(2*pi*4*t) + coeff(i,10)*cos(2*pi*5*t);
             
                     maxcoeff = max(basis_aux(0:0.01:Tmax));
                     
                     shift = (Umin+maxcoeff) + (Umax-Umin-2*maxcoeff)*rand(1);
                     
                     fStr = cellfun(@(f,c) strrep(func2str(f),'@(t)',...
                            sprintf('%.5g*',c)),basis,num2cell(coeff(i,:)),'UniformOutput',false);  
                     
                     fstrLong{i} = strjoin(fStr,' + ');
                     
                     fstrLong{i} = strcat(fstrLong{i}, ' + ', num2str(shift));
                    
                 end
                 
                 u1 = str2func(['@(t)',fstrLong{1}]);
                 u2 = str2func(['@(t)',fstrLong{2}]);
                 u3 = str2func(['@(t)',fstrLong{3}]);
                 u4 = str2func(['@(t)',fstrLong{4}]);
                 u5 = str2func(['@(t)',fstrLong{5}]);
                 u6 = str2func(['@(t)',fstrLong{6}]);
                 u7 = str2func(['@(t)',fstrLong{7}]);
                 u8 = str2func(['@(t)',fstrLong{8}]);
                 u9 = str2func(['@(t)',fstrLong{9}]);
                                                    
                 dataset{iTests}.uu = @(t) [u1(t); u2(t); u3(t); u4(t); u5(t);...
                                            u6(t); u7(t); u8(t); u9(t)];
                 
             end
             
             
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%             

         case 'Polynomial'
             
             N_basis = 5;
             basis = {@(t) t,@(t) t.^2,@(t) t.^3,@(t) t.^4,@(t) t.^5};
                       
                       
             for iTests = 1:N_samples
                 
                 dataset{iTests}.tt = [0 Tmax];
                 
                 TT = Tmax.^(-1:-1:-N_basis);
                 coeff = (Umax-Umin)/N_basis*rand(dimU, N_basis).*TT;
                 fstrLong = cell(1,dimU);
                 u = cell(1,dimU);
                 
                 for i = 1:dimU
                     
                     basis_aux = @(t) coeff(i,1)*t + coeff(i,2)*t.^2 + coeff(i,3)*t.^3 + coeff(i,4)*t.^4 + coeff(i,5)*t.^5;
             
                     maxcoeff = max(basis_aux(0:0.01:Tmax));
                                                    
                     shift = Umin + (Umax - maxcoeff - Umin)*rand(1);
                     
                     fStr = cellfun(@(f,c) strrep(func2str(f),'@(t)',...
                            sprintf('%.5g*',c)),basis,num2cell(coeff(i,:)),'UniformOutput',false);  
                     
                     fstrLong{i} = strjoin(fStr,' + ');
                     
                     fstrLong{i} = strcat(fstrLong{i}, ' + ', num2str(shift));
                    
                 end
                 
                 u1 = str2func(['@(t)',fstrLong{1}]);
                 u2 = str2func(['@(t)',fstrLong{2}]);
                 u3 = str2func(['@(t)',fstrLong{3}]);
                 u4 = str2func(['@(t)',fstrLong{4}]);
                 u5 = str2func(['@(t)',fstrLong{5}]);
                 u6 = str2func(['@(t)',fstrLong{6}]);
                 u7 = str2func(['@(t)',fstrLong{7}]);
                 u8 = str2func(['@(t)',fstrLong{8}]);
                 u9 = str2func(['@(t)',fstrLong{9}]);
                                                    
                 dataset{iTests}.uu = @(t) [u1(t); u2(t); u3(t); u4(t); u5(t);...
                                            u6(t); u7(t); u8(t); u9(t)];
                 
             end
     end
         
end
