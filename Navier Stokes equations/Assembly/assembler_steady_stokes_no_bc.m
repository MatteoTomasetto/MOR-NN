function [H,b] = assembler_steady_stokes_no_bc(fespace_u,fespace_p,fun,nu)
% Assemble steady stokes matrix and rhs with boundary conditions
% input=
%           fespace_u: finite elemnet space for velocity
%           fespace_p: finite elemnet space for pressure
%           fun: anonymous function or scalar of the forcing term
%               If scalar, fun must be [0;0] and the code is optimized
%           nu: anonymous function or scalar for the diffusion term. If
%           scalar, the code is optimized on structured meshes
%           
% output=
%           H: system matrix
%           b: right handside


n_nodes_u = size(fespace_u.nodes,1);
n_nodes_p = size(fespace_p.nodes,1);

integratef = 1;
if (~isa(fun,'function_handle'))
    if (fun(1) == 0 && fun(1) == 0)
        integratef = 0;
    else
        error('Constant fun can only be zero! Pass it as anonymous function instead');
    end
end

fun1 = @(x) [1 0]*fun(x);
fun2 = @(x) [0 1]*fun(x);

A = assemble_stiffness(nu,fespace_u);
B1 = assemble_divergence(fespace_u,fespace_p,'dx');
B2 = assemble_divergence(fespace_u,fespace_p,'dy');

if (integratef)
    b1 = assemble_rhs(fespace_u,fun1);
    b2 = assemble_rhs(fespace_u,fun2);
else
    b1 = zeros(n_nodes_u,1);
    b2 = zeros(n_nodes_u,1);
end

zero_mat_u = sparse(n_nodes_u,n_nodes_u);
zero_mat_p = sparse(n_nodes_p,n_nodes_p);
zero_mat_up = sparse(n_nodes_u,n_nodes_p);

H1 = [A zero_mat_u' -B1'];
H2 = [zero_mat_u A -B2'];
H3 = [-B1 -B2 zero_mat_p];

H = [H1;H2;H3];
b = [b1;b2;zeros(n_nodes_p,1)];