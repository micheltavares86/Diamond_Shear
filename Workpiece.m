classdef Workpiece < handle
    %WORKPIECE Class Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        workpiece_size = [10 10 10];
        Material       = [];
        style          = 'nanocutting';
        
    end % properties
    
    properties (SetAccess = private)
        XSi = [];
        YSi = [];
        ZSi = [];
        
    end % properties private
    
    methods
        function wp_generator(obj)
            a = obj.Material.a;
            Sinx = obj.workpiece_size(1)*a;
            Siny = obj.workpiece_size(2)*a;
            Sinz = obj.workpiece_size(3)*a;
            [jlim]=length(obj.Material.Points);
            
            for j = 1:jlim

                [obj.XSi{j},obj.YSi{j},obj.ZSi{j}] = meshgrid(0:a:Sinx,0:a:Siny,...
                    0:a:Sinz);
                Si{j} = [obj.XSi{j}(:),obj.YSi{j}(:),obj.ZSi{j}(:)];
                [s1, s2] = size(Si{j});
                klim = length(obj.Material.Points{j});
          
                for k = 1:klim 
                    workpiece(:,:,k) = repmat(...
                        obj.Material.Points{j}(k,:),s1,1) + Si{j};
                    
                end % for k
                obj.XSi{j} = workpiece(:,1,:);
                obj.XSi{j} = obj.XSi{j}(:);
                obj.YSi{j} = workpiece(:,2,:);
                obj.YSi{j} = obj.YSi{j}(:);
                obj.ZSi{j} = workpiece(:,3,:);
                obj.ZSi{j} = obj.ZSi{j}(:);
                clear workpiece

                icut =  find(obj.XSi{j}>Sinx); 
                icut = [find(obj.YSi{j}>Siny); icut];
                icut = [find(obj.ZSi{j}>Sinz); icut];
                obj.XSi{j}(icut) = [];
                obj.YSi{j}(icut) = [];
                obj.ZSi{j}(icut) = [];
                
            end % for j

        end % function
        
        function wp_plot(obj)
            figure
            jlim =length(obj.Material.Points);
            hold on
            for j=1:jlim
            plot3(obj.XSi{j}, obj.YSi{j},obj.ZSi{j},...
                'MarkerFaceColor',[0 0.44705882668495 0.7411764860153],...
                'MarkerSize',6,'Marker','o','LineStyle','none')
            end % for
            
            hold off
            axis equal
            grid on
                        
        end % wp_plot
        
    end % methods
    
end % classdef

