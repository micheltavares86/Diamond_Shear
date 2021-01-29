classdef SimulationFiles
    %SIMULATIONFILES Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        workpiece = [];
        Tool      = [];
        Style     = 'nanocutting';
        thickness = 100;        
        
    end % properties
    
    properties (SetAccess = private)
        strNatoms = [];
        Test = [];
    end % private properties
    
    methods
        function xyz_file(obj)
            % Extra info.
            % Atoms id.                                           
            jlim = length(obj.workpiece.Material.Points);
            klim = length(obj.Tool.Material.Points);

            for j = 1:klim              
                id{j} = 1:length(obj.Tool.X{j}(obj.Tool.i2{j}));
                id{j} = id{j}'; 
                
            end % for
            
            Tool_Displac_X = obj.workpiece.workpiece_size(1)*obj.workpiece.Material.a +...
                obj.thickness*tan(abs(obj.Tool.gama*pi/180));
            Tool_Displac_y = obj.workpiece.workpiece_size(2)*obj.workpiece.Material.a - obj.thickness;
            Tool_Displac_Z = 0.5*(obj.workpiece.workpiece_size(3)*obj.workpiece.Material.a...
                - obj.Tool.Tool_size(3));

            fid = fopen('diamond_points2.xyz','wt');
            
            obj.strNatoms = 0;
            for j = 1:jlim
                obj.strNatoms = obj.strNatoms + length(obj.workpiece.XSi{j});
            end %for 
            for j = 1:klim
                obj.strNatoms = obj.strNatoms +...
                    length(obj.Tool.X{j}(length(obj.Tool.i2{j})));
            end %for 
            
            obj.strNatoms = num2str(obj.strNatoms);            
            fprintf(fid,[obj.strNatoms '\n']);
            fprintf(fid,'\n');

            for j = 1:klim
                A = (obj.Tool.X{j}(obj.Tool.i2{j}) + Tool_Displac_X);
                B = (obj.Tool.Y{j}(obj.Tool.i2{j}) + Tool_Displac_y +...
                    obj.thickness + 1);
                C = (obj.Tool.Z{j}(obj.Tool.i2{j}) + Tool_Displac_Z);
                srtC = [A, B, C];
                
                strC = sprintf(obj.Tool.Material.strArray{j},srtC');

                fprintf(fid,strC);
                
            end % for  
            
            for j =1:jlim
                strSi = sprintf(obj.workpiece.Material.strArray{j},...
                    [obj.workpiece.XSi{j}, obj.workpiece.YSi{j},...
                    obj.workpiece.ZSi{j}]');
                fprintf(fid,strSi);
            end %for
            
            fclose(fid);
            
        end % function xyz_file
        
        function lmp_file(obj)
            jlim = length(obj.workpiece.Material.Points);
            klim = length(obj.Tool.Material.Points);
            
            Tool_Displac_X = obj.workpiece.workpiece_size(1)*...
                obj.workpiece.Material.a +...
                obj.thickness*tan(abs(obj.Tool.gama*pi/180));
            Tool_Displac_y = obj.workpiece.workpiece_size(2)*...
                obj.workpiece.Material.a - obj.thickness;
            Tool_Displac_Z = 0.5*(obj.workpiece.workpiece_size(3)*...
                obj.workpiece.Material.a - obj.Tool.Tool_size(3));           
            
            fid = fopen('diamond_points.lmp','wt');
            fprintf(fid, '#File generated without Atomsk\n');
            fprintf(fid, '\n');
            
            strNatomsWP = 0;
            for j = 1:jlim
                strNatomsWP = strNatomsWP +...
                    length(obj.workpiece.XSi{j});
            end %for 
            
            obj.strNatoms = strNatomsWP;
            for j = 1:klim
                obj.strNatoms = obj.strNatoms +...
                    length(obj.Tool.X{j}(obj.Tool.i2{j}));
            end %for
            str = sprintf('\t  %4.0f\t atoms\n', obj.strNatoms);
            fprintf(fid,str);
            
            fprintf(fid,'\t\t  4\t atom types');
            fprintf(fid, '\n');
            str = sprintf('\t  0.000000000\t  %4.8f  xlo xhi\n',...
                obj.workpiece.workpiece_size(1)*obj.workpiece.Material.a...
                + 2*obj.Tool.Tool_size(1));
            fprintf(fid,str);
            str = sprintf('\t  0.000000000\t  %4.8f  ylo yhi\n',...
                obj.workpiece.workpiece_size(2)*obj.workpiece.Material.a...
                + 2*obj.Tool.Tool_size(2));
            fprintf(fid,str);
            str = sprintf('\t  0.000000000\t  %4.8f  zlo zhi\n',...
                obj.Tool.Tool_size(3));
            fprintf(fid,str);
            fprintf(fid, '\n');
            fprintf(fid, 'Masses\n');
            fprintf(fid, '\n');
            
            for j = 1:klim
                str = sprintf('\t\t  %i \t %4.3f \t # %s\n',...
                    [j obj.Tool.Material.Mass{j}...
                    obj.Tool.Material.Symbol{j}]);
                fprintf(fid, str);
            end % for
            for j = 1:jlim
                for k = (klim+1):jlim
                    str = sprintf('\t\t  %i \t %4.3f \t # %s\n',...
                        [j+klim obj.workpiece.Material.Mass{j}...
                        obj.workpiece.Material.Symbol{j}]);
                    fprintf(fid, str);
                end % for
            end % for            
            
            fprintf(fid, '\n');
            fprintf(fid, 'Atoms # atomic\n');
            fprintf(fid, '\n');
            
            
            for j = 1:klim
                id = 1:length(obj.Tool.X{j}(obj.Tool.i2{j}));
                id = id';
                A = (obj.Tool.X{j}(obj.Tool.i2{j}) + Tool_Displac_X);
                B = (obj.Tool.Y{j}(obj.Tool.i2{j}) + Tool_Displac_y +...
                    obj.thickness + 1);
                C = (obj.Tool.Z{j}(obj.Tool.i2{j}) + Tool_Displac_Z);
                srtC = [id, A, B, C];
                str = ['%i', '    ',  num2str(j),...
                    '    %4.3f    %4.3f    %4.3f\n'];
                
                strC = sprintf(str,srtC');

                fprintf(fid,strC);
                
            end % for
            
            increment = length(id);
            for j = 1:jlim
                id = 1:length(obj.workpiece.XSi{j});
                id = id + increment;
                increment = id(end);
                id = id';
                A = (obj.workpiece.XSi{j});
                B = (obj.workpiece.YSi{j});
                C = (obj.workpiece.ZSi{j});
                srtWP = [id, A, B, C];
                str = ['%i' , '    ',  num2str(j+klim),...
                    '    %f    %f    %f\n'];
                
                strWP = sprintf(str,srtWP');

                fprintf(fid,strWP);
                
            end % for

            fclose(fid); 
            
        end % function lmp_file
        
        function data_file(obj)
            % LAMMPS file (.txt file)
            
            a    = obj.Tool.Material.a;
            aSi  = obj.workpiece.Material.a;
            Sinx = obj.workpiece.workpiece_size(1)*a;
            Siny = obj.workpiece.workpiece_size(2)*a;
            Sinz = obj.workpiece.workpiece_size(3)*a;
            
            Tool_Displac_X = obj.workpiece.workpiece_size(1)*...
                obj.workpiece.Material.a +...
                obj.thickness*tan(abs(obj.Tool.gama*pi/180));
            Tool_Displac_y = obj.workpiece.workpiece_size(2)*...
                obj.workpiece.Material.a - obj.thickness;
            Tool_Displac_Z = 0.5*(obj.workpiece.workpiece_size(3)*...
                obj.workpiece.Material.a - obj.Tool.Tool_size(3));   

            fid = fopen('Tool_Test.txt','wt');

            fprintf(fid,'#------------------Initialization--------------------------\n');
            fprintf(fid,'\n');
            fprintf(fid,'#-----------------Standard MD setup------------------------\n');
            fprintf(fid,'\n');
            fprintf(fid,'units		metal\n');
            fprintf(fid,'boundary	s s p\n');
            fprintf(fid,'atom_style	atomic\n');
            fprintf(fid,'\n');
            fprintf(fid,'#-----------------Create simulation box--------------------\n');
            fprintf(fid,'\n');
            fprintf(fid,'lattice		diamond 5.431\n');
            fprintf(fid,'read_data	diamond_points.lmp\n');
            fprintf(fid,'\n');
            fprintf(fid,'#------------------Setup potential------------------------\n');
            fprintf(fid,'\n');
            fprintf(fid,'pair_style tersoff\n');
            fprintf(fid,'pair_coeff * * SiC.tersoff C Si Si Si\n');
            fprintf(fid,'\n');
            fprintf(fid,'neighbor	0.1 bin\n');
            fprintf(fid,'neigh_modify	delay 10\n');
            fprintf(fid,'\n');

            str = sprintf(...
                'region    tool   block  0.0  INF  %4.1f  INF   0.0  INF\n',...
                Siny/aSi + 1);
            fprintf(fid,str);

            str = sprintf(...
                'region    mobile block  2.0  INF  2.0  %4.1f  0.0  %4.1f\n',...
                [(Siny/aSi + 1) (Sinz/aSi +3)]);
            fprintf(fid,str);

            str = sprintf(...
                'region    termo  block  1.0  INF  1.0  %4.1f  0.0  %4.1f\n',...
                [(Siny/aSi + 1) (Sinz/aSi +3)]);
            fprintf(fid,str);

            str = sprintf(...
                'region    wpiece block  0.0   %4.1f  0.0  %4.1f  0.0  %4.1f\n',...
                [(Sinx/aSi + 1) (Siny/aSi + 1) (Sinz/aSi +3)]);
            fprintf(fid,str);

            fprintf(fid,'\n');
            fprintf(fid,'group		tool      region   tool\n');
            fprintf(fid,'group		wpiece    region   wpiece\n');
            fprintf(fid,'group		termo     region   termo\n');
            fprintf(fid,'group		mobile    region   mobile\n');
            fprintf(fid,'group		boundary  subtract wpiece termo\n');
            fprintf(fid,'group		termo     subtract termo mobile\n');
            fprintf(fid,'\n');

            strxhi = num2str(max(obj.Tool.X{1}(obj.Tool.i2{1}))/a + Tool_Displac_X/aSi);
            strxlo = num2str(max(obj.Tool.X{1}(obj.Tool.i2{1}))/a + Tool_Displac_X/aSi - 1);
            stryhi = num2str(max(obj.Tool.X{1}(obj.Tool.i2{1}))/a + Tool_Displac_X/aSi);
            strylo = num2str(max(obj.Tool.X{1}(obj.Tool.i2{1}))/a + Tool_Displac_X/aSi - 1);


            str = sprintf('displace_atoms tool move	0.0 %4.f 0.0\n', -(obj.thickness+1)/aSi);
            fprintf(fid,str);

            fprintf(fid,'\n');
            fprintf(fid,'set			group boundary type 4\n');
            fprintf(fid,'set			group termo    type 3\n');
            fprintf(fid,'\n');
            fprintf(fid,'compute		new3d mobile temp\n');
            fprintf(fid,'compute		new2d mobile temp/partial 0 1 1\n');
            fprintf(fid,'compute		new4d termo temp\n');
            fprintf(fid,'compute		new5d termo temp/partial 0 1 1\n');
            fprintf(fid,'compute 	1 all pressure thermo_temp\n');
            fprintf(fid,'\n');
            fprintf(fid,'#--------------------Equilibration------------------------\n');
            fprintf(fid,'\n');
            fprintf(fid,'velocity	mobile create 300.0 5812775 temp new3d\n');
            fprintf(fid,'\n');
            fprintf(fid,'fix		1 all nve\n');
            fprintf(fid,'fix		2 boundary setforce 0.0 0.0 0.0\n');
            fprintf(fid,'fix		4 tool	   setforce 0.0 0.0 0.0\n');
            fprintf(fid,'fix		5 termo	   nvt temp 300.0 300.0 0.01\n');
            fprintf(fid,'\n');
            fprintf(fid,'fix		3 mobile temp/rescale 10 300.0 300.0 10.0 1.0\n');
            fprintf(fid,'fix_modify	3 temp new3d \n');
            fprintf(fid,'\n');
            fprintf(fid,'thermo		25\n');
            fprintf(fid,'thermo_modify	temp new3d\n');
            fprintf(fid,'\n');
            fprintf(fid,'reset_timestep	0\n');
            fprintf(fid,'timestep	0.001 \n');
            fprintf(fid,'\n');
            fprintf(fid,'minimize 1.0e-4 1.0e-6 25 1000\n');
            fprintf(fid,'\n');
            fprintf(fid,'run		100\n');
            fprintf(fid,'\n');
            fprintf(fid,'#-----------------------Shear---------------------------\n');
            fprintf(fid,'\n');
            fprintf(fid,'velocity	tool set -2.0 0 0\n');
            fprintf(fid,'velocity	mobile ramp vx 0.0 1.0 y 1.4 8.6 sum yes\n');
            fprintf(fid,'\n');
            fprintf(fid,'unfix		3\n');
            fprintf(fid,'fix		3 mobile temp/rescale 10 300.0 300.0 10.0 1.0\n');
            fprintf(fid,'fix_modify	3 temp new2d\n');
            fprintf(fid,'\n');
            fprintf(fid,'thermo		100\n');
            fprintf(fid,'thermo_modify	temp new2d\n');
            fprintf(fid,'\n');
            fprintf(fid,'dump 1 all custom 100 dump.defo.* id type x y z\n');
            fprintf(fid,'\n');
            fprintf(fid,'reset_timestep	0\n');
            fprintf(fid,'\n');
            fprintf(fid,'run            5000\n');

            fclose(fid);
        end % function data_file
    end
    
end

