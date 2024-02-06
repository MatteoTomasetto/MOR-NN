# Model Order Reduction of PDEs by Neural Networks

Numerical analysis usually requires a huge effort in terms
of computations, memory storage and time because of the high order of
the models. Here it is the necessity of relying on a different numerical
model which requires a sustainable effort while still being able to represent
suffciently well the outputs of interest. 

The aim of this project is to study and exploit a model order reduction
(MOR) method based on artificial neural networks in the case of Heat Equation and 2D
unsteady Navier-Stokes equations.

In order to use this code, you need to install the model-learning library (https://model-learning.gitlab.io/model-learning/) in Matlab and plug the code in the "Example" folder.

## Code

- `Heat Equation` folder contains the Matlab code to generate the dataset of input-output pairs and to fit the artificial neural network of interest in the case of Heat Equation. In particular, the input was a collection of nine time-dependent functions which represented
the thermal conductivity coefficient in nine subdomains of our problem and the output was
the temperature in three points of the domain.

- `Navier-Stokes Equations` folder contains the Matlab code to generate the dataset of input-output pairs and to fit the artificial neural network of interest in the case of 2D unsteady Navier-Stokes in a channel with the presence of an obstacle. In particular, we selected as inputs the velocity of the fluid on the inflow boundary and the Reynolds number, while as output we chose the drag and the lift coefficients of the forces on the obstacle.

## Authors
* [Matteo Tomasetto](https://github.com/MatteoTomasetto)
Simone Pescuma
Cipriano Innella
