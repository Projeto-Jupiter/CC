# Control Canards

Control canards is a project to control the roll moment of the rocket during flight. This project uses MATLAB's Simulink application to model flight and, using it, put the controller to test. 

## Characteristics
### Flight Simulation
The rocket's flight simulation model has 6 degrees of freedom, including variable mass effects. It doesn't consider descent - as the controller won't be operating during descent - and depends of pre-determined initial conditions as it won't either simulate and operate during rail ascent phase. 

As inspiration, the model uses another flight simulator from Projeto Jupiter called RocketPy - a extremely precise 6DOF rocket's flight simulator. This can be accessed by clicking here: [![Open in Github](https://github.com/giovaniceotto/RocketPy)]

### Active control 
The _in development_ flight control system is based on a Matlab project called *NASA HL-20 Lifting Body Airframe*. The project's controller. At first moment, the objective is starting with the roll moment and evolve to a full flight control.

## Prerequisites
Matlab >= R2016a
Simulink >= R2016a
Aerospace Blockset >= R2016a

## Authors
* **Adriano Augusto Antongiovanni**
* **Bruno Abdulklech Sorban**
* **Caio Nascimento Balreira**
* **Mateus Stano Junqueira**
* **Patrick Sampaio dos Santos Brandão**
* **Victor Campos Jinsi**

## Acknowledgements
He would like to thank all support from professors and students involved with the creation of this software. A special thanks to Giovani Ceotto who gently used his time to support and share his knowledge, which are essential in the creation of this project.
