classdef Material < handle
    % MATERIAL Class where the material type and properties are defined.
    %   The material can a monoatomic or diatomic material.
    
    properties       
        Name        = 'Carbon_Diamond';
        LatticeType = 'Diamond';
        Symbol      = {'C'};
        Mass        = {12.0};
        a           = 3.567;

    end % properties
    
    properties (SetAccess = private)
        Points      = {};
        strArray    = [];
        
    end % properties private
    
    methods 
        function LatticeStructure(obj)
        
            switch obj.LatticeType
                case 'Diamond'
                    obj.Points{1} =   [0, 0, 0;...
                    obj.a/2, 0, obj.a/2;... 
                    3*obj.a/4, obj.a/4, obj.a/4;...
                    obj.a/4, obj.a/4, 3*obj.a/4;...
                    0, obj.a/2, obj.a/2;...
                    obj.a/2, obj.a/2, 0;...
                    obj.a/4, 3*obj.a/4, obj.a/4;...
                    3*obj.a/4, 3*obj.a/4, 3*obj.a/4];
                
                    obj.strArray{1} = [obj.Symbol{1}...
                        ' %4.3f %4.3f %4.3f\n'];
                    
                case 'Diamond_2'
                    obj.Points{1} =   [0, 0, 0;...
                    obj.a/2, 0, obj.a/2;...                     
                    0, obj.a/2, obj.a/2;...
                    obj.a/2, obj.a/2, 0];
                    
                    obj.Points{2} = [3*obj.a/4, obj.a/4, obj.a/4;...
                    obj.a/4, obj.a/4, 3*obj.a/4;...
                    obj.a/4, 3*obj.a/4, obj.a/4;...
                    3*obj.a/4, 3*obj.a/4, 3*obj.a/4];
                
                    for i = 1:length(obj.Symbol)
                        obj.strArray{i} = [obj.Symbol{i}...
                            ' %4.3f %4.3f %4.3f\n'];
                    end %for
                
            end % switch
            
        end % function
        
    end % methods
    
end % class

