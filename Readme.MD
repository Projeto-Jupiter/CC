# Control Canards

Control canards is a project to control the roll moment of the rocket during flight. This project uses MATLAB's Simulink application to model flight and, using it, put the controller to test. 

## Characteristics
### Flight Simulation
The rocket's flight simulation model has 6 degrees of freedom, including variable mass effects. It doesn't consider descent - as the controller won't be operating during descent - and depends of pre-determined initial conditions as it won't either simulate and operate during rail ascent phase. 

As inspiration, the model uses another flight simulator from Projeto Jupiter called [RocketPy](https://github.com/giovaniceotto/RocketPy) - a extremely precise 6DOF rocket's flight simulator.

### Active control 
The _in development_ flight control system is based on a Matlab project called *NASA HL-20 Lifting Body Airframe*. The project's controller. At first moment, the objective is starting with the roll moment and evolve to a full flight control.

### Motivation
_Project Jupiter_ desires to improve flight perfomance of the rockets, therefore a control based rocket it's a natural path, we will strat the control development by controlling the roll moment, but in the future we desired to control others characteristics of the flight like apogee and trajectory.

## Prerequisites
* Matlab >= R2016a
* Simulink >= R2016a
* Aerospace Blockset >= R2016a

## Authors
* **Adriano Augusto Antongiovanni**
* **Bruno Abdulklech Sorban**
* **Caio Nascimento Balreira**
* **Mateus Stano Junqueira**
* **Patrick Sampaio dos Santos Brandão**
* **Victor Campos Jinsi**

## Acknowledgements
We would like to thank all support from professors and students involved with the creation of this software. A special thanks to Giovani Ceotto who gently used his time to support and share his knowledge, which are essential in the creation of this project.
