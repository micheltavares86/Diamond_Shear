clear all
clear classes
clc

C              = Material();
C.Name         = 'Carbom_Diamond';
C.LatticeType  = 'Diamond';
C.Symbol       = {'C'};
C.a            = 3.567;
C.LatticeStructure();

GaP              = Material();
GaP.Name         = 'GaP';
GaP.LatticeType  = 'Diamond_2';
GaP.Symbol       = {'P' 'Ga'};
GaP.Mass              = {70 31};
GaP.a            = 5.431;
GaP.LatticeStructure();

WP                  = Workpiece();
WP.workpiece_size   = [100 60 12.5*3.567];
WP.Material         = GaP;
WP.style            = 'nanocutting';
WP.wp_generator()
%WP2.wp_plot()

Tool                  = Tool();
Tool.Tool_size   = [60 60 12.5];
Tool.Material         = C;
Tool.style            = 'nanocutting';
Tool.raio             = 100;
Tool.gama             = -45;
Tool.alfa             = 10;
Tool.tool_generator()
%Tool.Tool_plot()

Simulation = SimulationFiles();
Simulation.workpiece = WP;
Simulation.Tool      = Tool;
Simulation.lmp_file()
Simulation.data_file()


