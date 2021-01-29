classdef Tool < handle
    %WORKPIECE Class Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Tool_size = [10 10 10];
        Material       = [];
        style          = 'nanocutting';
        raio           = 100;
        gama           = -45;
        alfa           = 10;
        beta           = 125;
        
    end % properties
    
    properties (SetAccess = private)
        X = [];
        Y = [];
        Z = [];
        i2 = [];
        
    end % properties private
    
 methods
        function tool_generator(obj)
            obj.beta = 90 - obj.gama - obj.alfa;
            a = obj.Material.a;
            nx = obj.Tool_size(1)*a;
            ny = obj.Tool_size(2)*a;
            nz = obj.Tool_size(3)*a;            
            [jlim]= length(obj.Material.Points);            
            
            for j = 1:jlim

                [obj.X{j},obj.Y{j},obj.Z{j}] = meshgrid(-nx:a:nx,0:a:ny,...
                    0:a:nz);
                Si{j} = [obj.X{j}(:),obj.Y{j}(:),obj.Z{j}(:)];
                [s1, s2] = size(Si{j});
                klim = length(obj.Material.Points{j});
          
                for k = 1:klim 
                    workpiece(:,:,k) = repmat(...
                        obj.Material.Points{j}(k,:),s1,1) + Si{j};
                    
                end % for k
                obj.X{j} = workpiece(:,1,:);
                obj.X{j} = obj.X{j}(:);
                obj.Y{j} = workpiece(:,2,:);
                obj.Y{j} = obj.Y{j}(:);
                obj.Z{j} = workpiece(:,3,:);
                obj.Z{j} = obj.Z{j}(:);
                clear workpiece

                icut =  find(obj.X{j}>19*a); 
                icut = [find(obj.Y{j}>ny); icut];
                icut = [find(obj.Z{j}>nz); icut];
                obj.X{j}(icut) = [];
                obj.Y{j}(icut) = [];
                obj.Z{j}(icut) = [];
                clear icut
                
                [theta, rho, z] = cart2pol(obj.X{j},obj.Y{j},obj.Z{j});
                i{j}  = find(theta<=((obj.beta+obj.alfa)*pi/180) &...
                    theta>=(obj.alfa*pi/180) & z == 0);
                i2{j} = find(theta<=((obj.beta+obj.alfa)*pi/180) &...
                    theta>=(obj.alfa*pi/180));

                % tool radius.
                obj.X{j} = obj.X{j}-obj.raio + (obj.raio*tan(...
                    -pi*obj.gama/180));
                obj.Y{j} = obj.Y{j}-obj.raio;
                [theta, rho, z] = cart2pol(obj.X{j},obj.Y{j},obj.Z{j});
                i3{j} = find(theta>(-2*pi+(obj.gama*pi/180)) &...
                    theta<(-pi/2) & rho>=obj.raio);
                obj.X{j} = obj.X{j}+obj.raio - (obj.raio*tan(...
                    -pi*obj.gama/180));
                obj.Y{j} = obj.Y{j}+obj.raio;
                fullarray = linspace(1,length(obj.Z{j}),length(obj.Z{j}));
                i3{j} = setdiff(fullarray, i3{j});
                clear('fullarray');
                obj.i2{j} = intersect(i2{j},i3{j});
                
            end % for j

        end % function tool_genreator
        
        function Tool_plot(obj)
            figure
            plot3(obj.X{1}(obj.i2), obj.Y{1}(obj.i2),obj.Z{1}(obj.i2),...
                'MarkerFaceColor',[0 0.44705882668495 0.7411764860153],...
                'MarkerSize',6,'Marker','o','LineStyle','none')
            axis equal
            grid on
            
        end % Tool_plot
        
    end % methods
    
 end % classdef

