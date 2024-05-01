local 
   % Vous pouvez remplacer ce chemin par celui du dossier qui contient LethOzLib.ozf
   % Please replace this path with your own working directory that contains LethOzLib.ozf

   % Dossier = {Property.condGet cwdir '/home/max/FSAB1402/Projet-2017'} % Unix example
   Dossier = {Property.condGet cwdir 'C:\\Users\\Utilisateur\\Bureau\\Oz\\Projet\\Oz'}
   % Dossier = {Property.condGet cwdir 'C:\\Users\Thomas\Documents\UCL\Oz\Projet'} % Windows example.
   LethOzLib

   % Les deux fonctions que vous devez implémenter
   % The two function you have to implement
   Next
   DecodeStrategy
   
   % Hauteur et largeur de la grille
   % Width and height of the grid
   % (1 <= x <= W=24, 1 <= y <= H=24)
   W = 24
   H = 24

   Options
in
   % Merci de conserver cette ligne telle qu'elle.
   % Please do NOT change this line.
   [LethOzLib] = {Link [Dossier#'/'#'LethOzLib.ozf']}
   {Browse LethOzLib.play}

%%%%%%%%%%%%%%%%%%%%%%%%
% Your code goes here  %
% Votre code vient ici %
%%%%%%%%%%%%%%%%%%%%%%%%

   local
      % Déclarez vos functions ici
      % Declare your functions here
         Space = spaceship(
            positions:[pos(x:4 y:2 to:east) pos(x:3 y:2 to:east) pos(x:2 y:2 to:east)]
            effects:nil
            strategy : nil 
            seismicCharge : nil
         )

         D = dropSeismicCharge(true|false|true|false|true|nil) % To access the list in the dropSeismicCHarge we have to use this call D.1

         
         Spaceship = spaceship(
            positions:[pos(x:4 y:3 to:south) pos(x:4 y:2 to:south) pos(x:4 y:1 to:east)]
           effects: [revert scrap wormhole(x:10 y:1) wormhole(x:1 y:5) scrap revert]
           strategy : nil
           )


         FuriousSpaceship = spaceship(
            positions:[pos(x:4 y:1 to:west) pos(x:4 y:2 to:north) pos(x:4 y:3 to:north)]
            effects:nil
            strategy : [turn(right) turn(right) repeat([turn(right)] times:2)]
            )
      
         fun {DeleteWormhole Spaceship}
            fun{DeleteWormhole Spaceship Effets}
               case Effets
               of nil then nil 
               [] H|T then 
                  if H == scrap orelse H == revert then
                     H|{DeleteWormhole Spaceship T} 
                  else 
                     {DeleteWormhole Spaceship T}
                  end 
               end 
            end 
         in   
            {DeleteWormhole Spaceship Spaceship.effects}
         end 

         %{Browse {DeleteWormhole Spaceship}}

         fun {DeleteScrap Spaceship} 
            fun {DeleteScrap Spaceship Effets}
               case Effets
               of nil then nil 
               [] H|T then 
                  if H \= scrap  then
                     H|{DeleteScrap Spaceship T} 
                  else 
                     {DeleteScrap Spaceship T}
                  end 
               end 
            end 
         in 
            {DeleteScrap Spaceship Spaceship.effects}
         end 

         %{Browse {DeleteScrap Spaceship}}

         fun {DeleteRevert Spaceship} 
            fun {DeleteRevert Spaceship Effets} 
               case Effets 
               of nil then nil 
               [] H|T then 
                  if H \= revert then 
                     H|{DeleteRevert Spaceship T} 
                  else 
                     {DeleteRevert Spaceship T}
                  end 
               end 
            end 
         in 
            {DeleteRevert Spaceship Spaceship.effects} 
         end 

         %{Browse {DeleteRevert Spaceship}}

         fun {Scrap Spaceship}
            fun {Scrap Spaceship Positions Head} 
               case Positions
               of nil then
                  if Head.to == east then  
                     local Last in 
                     Last = pos(x:Head.x-1 y:Head.y to:Head.to)
                     Last|nil
                     end 
                  elseif Head.to == west then 
                     local Last in 
                     Last = pos(x:Head.x+1 y:Head.y to:Head.to) 
                     Last|nil
                     end 
                  elseif Head.to == north then 
                     local Last in 
                     Last = pos(x:Head.x y:Head.y+1 to:Head.to) 
                     Last|nil
                     end 
                  elseif Head.to == south then 
                     local Last in 
                     Last = pos(x:Head.x y:Head.y-1 to: Head.to) 
                     Last|nil
                     end
                  end 
               [] V|D then V|{Scrap Spaceship D V}
               end 
                
            end 
         in 
            {Scrap Spaceship Spaceship.positions Spaceship.positions.1}
         end 

         %{Browse {Scrap Spaceship}}

         fun {Reverse Spaceship}
            fun {Reverse Spaceship Positions NewPositions}
               case NewPositions 
               of nil then
                  {Reverse Spaceship Positions.2 Positions.1|nil}
               else
                  case Positions 
                  of nil then 
                     local NewSpaceship in 
                     NewSpaceship = spaceship(positions:NewPositions effects:Spaceship.effects)
                     end 
                  [] H|T then 
                     {Reverse Spaceship T H|NewPositions}
                  end 
               end
            end 
         in 
            {Reverse Spaceship Spaceship.positions nil}
         end 

         %{Browse {Reverse Spaceship}}

         fun {TailSpacePos Spaceship} 
            fun {TailSpacePos Spaceship Positions}
               local NewSpaceship in
                  if Positions.1 == nil then 
                     NewSpaceship = {AdjoinAt Spaceship positions nil}
                  else 
                     NewSpaceship = {AdjoinAt Spaceship positions Positions.2}
                  end 
               end 
            end 
         in 
            {TailSpacePos Spaceship Spaceship.positions }
         end 

         %R = {Reverse Spaceship}
         %{Browse {TailSpacePos {TailSpacePos {TailSpacePos R}}}}

         %{Browse {TailSpacePos Spaceship}}

         fun {Revert Spaceship}
            fun {Revert Spaceship Inverse Positions}
               case Positions 
               of nil then nil 
               [] V|D then   
                  if V.to == east then 
                     local Element in 
                        Element = pos(x:V.x y:V.y to:west) 
                        Element|{Revert Spaceship Inverse D}
                     end 
                  elseif V.to == west then 
                     local Element in 
                        Element = pos(x:V.x y:V.y to:east) 
                        Element|{Revert Spaceship Inverse D}
                     end 
                  elseif V.to == north then 
                     local Element in 
                        Element = pos(x:V.x y:V.y to:south) 
                        Element|{Revert Spaceship Inverse D}
                     end 
                  elseif V.to == south then 
                     local Element in 
                        Element = pos(x:V.x y:V.y to:north) 
                        Element|{Revert Spaceship Inverse D}
                     end   
                  end 
               end 
            end 
         in 
            local Inverse in 
            Inverse = {Reverse Spaceship} 
            {Revert Spaceship Inverse Inverse.positions}
            end 
         end

         %{Browse {Revert Spaceship}}
         

         fun {Worm Spaceship}
            fun {Worm Spaceship Positions Teleport}
               case Positions 
               of nil then nil 
               [] V|D then 
                  pos(x:V.x+Teleport.x y:V.y+Teleport.y to:V.to)|{Worm Spaceship D Teleport}
               end 
            end 
         in 
            {Worm Spaceship Spaceship.positions Spaceship.effects.1}
         end 

         %{Browse {Worm Spaceship}}

         fun {Forward Spaceship}
            fun {Forward Spaceship Positions Stop}
               case Positions
               of nil then nil 
               [] V|D then 
                  if V.to == east andthen Stop == false then
                        local Newpos in  
                        Newpos = pos(x:V.x y:V.y to:V.to)
                        pos(x:V.x+1 y:V.y to:V.to)|{Forward Spaceship Newpos|D true}  
                        end    
                  elseif V.to == south andthen Stop == false then 
                        local Newpos in  
                        Newpos = pos(x:V.x y:V.y to:V.to)
                        pos(x:V.x y:V.y+1 to:V.to)|{Forward Spaceship Newpos|D true}  
                        end   
                  elseif V.to == north andthen Stop == false then 
                        local Newpos in  
                        Newpos = pos(x:V.x y:V.y to:V.to)
                        pos(x:V.x y:V.y-1 to:V.to)|{Forward Spaceship Newpos|D true}  
                        end   
                  elseif V.to == west andthen Stop == false then
                        local Newpos in 
                        Newpos = pos(x:V.x y:V.y to:V.to)
                        pos(x:V.x-1 y:V.y to:V.to)|{Forward Spaceship Newpos|D true} 
                        end 
                  else
                     if {Length D} == 1 then V|nil 
                     else 
                        V|{Forward Spaceship D true}
                     end 
                  end 
               end  
            end 
         in 
            {Forward Spaceship Spaceship.positions false}
         end 

         fun {Left Spaceship}
            fun {Left Spaceship Positions Stop} 
               case Positions
               of nil then nil 
               [] V|D then 
                  if V.to == east andthen Stop == false then
                        local Newpos in  
                        Newpos = pos(x:V.x y:V.y to:north)
                        pos(x:V.x y:V.y-1 to:north)|{Left Spaceship Newpos|D true}  
                        end    
                  elseif V.to == south andthen Stop == false then 
                        local Newpos in  
                        Newpos = pos(x:V.x y:V.y to:east)
                        pos(x:V.x+1 y:V.y to:east)|{Left Spaceship Newpos|D true}  
                        end   
                  elseif V.to == north andthen Stop == false then 
                        local Newpos in  
                        Newpos = pos(x:V.x y:V.y to:west)
                        pos(x:V.x-1 y:V.y to:west)|{Left Spaceship Newpos|D true}  
                        end   
                  elseif V.to == west andthen Stop == false then
                        local Newpos in 
                        Newpos = pos(x:V.x y:V.y to:south)
                        pos(x:V.x y:V.y+1 to:south)|{Left Spaceship Newpos|D true} 
                        end 
                  else
                     if {Length D} == 1 then V|nil 
                     else 
                        V|{Left Spaceship D true}
                     end 
                  end
               end 
            end
         in 
            {Left Spaceship Spaceship.positions false}
         end 

         fun {Right Spaceship} 
            fun {Right Spaceship Positions Stop}
               case Positions
               of nil then nil 
               [] V|D then 
                  if V.to == east andthen Stop == false then
                        local Newpos in  
                        Newpos = pos(x:V.x y:V.y to:south)
                        pos(x:V.x y:V.y+1 to:south)|{Right Spaceship Newpos|D true}  
                        end    
                  elseif V.to == south andthen Stop == false then 
                        local Newpos in  
                        Newpos = pos(x:V.x y:V.y to:west)
                        pos(x:V.x-1 y:V.y to:west)|{Right Spaceship Newpos|D true}  
                        end   
                  elseif V.to == north andthen Stop == false then 
                        local Newpos in  
                        Newpos = pos(x:V.x y:V.y to:east)
                        pos(x:V.x+1 y:V.y to:east)|{Right Spaceship Newpos|D true}  
                        end   
                  elseif V.to == west andthen Stop == false then
                        local Newpos in 
                        Newpos = pos(x:V.x y:V.y to:north)
                        pos(x:V.x y:V.y-1 to:north)|{Right Spaceship Newpos|D true} 
                        end 
                  else
                     if {Length D} == 1 then V|nil 
                     else 
                        V|{Right Spaceship D true}
                     end 
                  end
               end 
            end 
         in 
            {Right Spaceship Spaceship.positions false} 
         end

         fun {Move Spaceship Instruction}
            if Instruction == forward then
               {Forward Spaceship}
            elseif Instruction == turn(right) then
               {Right Spaceship}
            else 
               {Left Spaceship} 
            end   
         end

         fun{Repeat Strategy}
            case Strategy 
            of nil then nil
            [] repeat(M times:T) then 
               if T == 0 then
                  if M.2 == nil then 
                     nil 
                  else  
                     {Repeat M.2.1}
                  end
               else
                  M.1|{Repeat repeat(M times:T-1)}
               end 
            end
         end 

         %{Browse {Repeat R}}
         
         %{Browse {Move FuriousSpaceship turn(right)}}

         fun {Effects Spaceship Instruction} 
            fun {Effects Spaceship Instruction Effets}
               local NewSpaceship in
                  case Effets 
                  of nil then 
                     NewSpaceship = spaceship(positions:{Move Spaceship Instruction} effects:Effets) 
                  [] V|D then 
                     case V 
                     of nil then nil 
                     [] scrap then
                        NewSpaceship = spaceship(positions:{Scrap Spaceship} effects:{DeleteScrap Spaceship}) 
                     [] revert then 
                        NewSpaceship = spaceship(positions:{Revert Spaceship} effects:{DeleteRevert Spaceship})
                     [] wormhole(x:X y:Y) then  
                        NewSpaceship = spaceship(positions:{Worm Spaceship} effects:{DeleteWormhole Spaceship})
                     end 
                  end 
               end 
            end 
         in 
            {Effects Spaceship Instruction Spaceship.effects}
         end    


          % Ajouter une nouvelle position à la liste de positions du vaisseau spatial
          Testspace = {AdjoinAt Spaceship positions {Scrap Spaceship}}
          %{Browse Testspace}
   in
   
      % La fonction qui renvoit les nouveaux attributs du serpent après prise
      % en compte des effets qui l'affectent et de son instruction
      % The function that computes the next attributes of the spaceship given the effects
      % affecting him as well as the instruction
      % 
      % instruction ::= forward | turn(left) | turn(right)
      % P ::= <integer x such that 1 <= x <= 24>
      % direction ::= north | south | west | east
      % spaceship ::=  spaceship(
      %               positions: [
      %                  pos(x:<P> y:<P> to:<direction>) % Head
      %                  ...
      %                  pos(x:<P> y:<P> to:<direction>) % Tail
      %               ]
      %               effects: [scrap|revert|wormhole(x:<P> y:<P>)|... ...]
      %            )
      fun {Next Spaceship Instruction}
         local ReturnSpaceship EffetShip in 
            EffetShip = {Effects Spaceship Instruction}
            case Spaceship.effects
            of nil then EffetShip
            [] V|D then 
               case V 
               of nil then nil 
               [] scrap then 
                  ReturnSpaceship = spaceship(positions:{Move EffetShip Instruction} effects:EffetShip.effects)
               [] revert then 
                  ReturnSpaceship = spaceship(positions:{Move EffetShip Instruction} effects:EffetShip.effects) 
               [] wormhole(x:X y:Y) then
                  ReturnSpaceship = spaceship(positions:{Move EffetShip Instruction} effects:EffetShip.effects) 
               end   
            end 
         end 
      end   
         %R = {Next Spaceship turn(right)}
         %{Browse R}
         %{Browse {Next R turn(right)}}

      % La fonction qui décode la stratégie d'un serpent en une liste de fonctions. Chacune correspond
      % à un instant du jeu et applique l'instruction devant être exécutée à cet instant au spaceship
      % passé en argument
      % The function that decodes the strategy of a spaceship into a list of functions. Each corresponds
      % to an instant in the game and should apply the instruction of that instant to the spaceship
      % passed as argument
      %
      % strategy ::= <instruction> '|' <strategy>
      %            | repeat(<strategy> times:<integer>) '|' <strategy>
      %            | nil
      fun {DecodeStrategy Strategy}
         case Strategy of nil then nil
         [] H|T then 
            case {Label H} of turn then
               case H of turn(right) then
                  fun {$ Spaceship} {Next Spaceship H} end | {DecodeStrategy T}
               [] turn(left) then
                  fun {$ Spaceship} {Next Spaceship H} end | {DecodeStrategy T}
               end
            [] repeat then
               case H.1 of nil then nil
               [] F|S then
                  {DecodeStrategy {Append {Repeat H} T}}
               end
            [] forward then 
               fun {$ Spaceship} {Next Spaceship H} end | {DecodeStrategy T}
            end
         end
      end

      %DecodedFunctions = {DecodeStrategy FuriousSpaceship.strategy}   
      %{Browse DecodedFunctions}





      % Options
      Options = options(
		   % Fichier contenant le scénario (depuis Dossier)
		   % Path of the scenario (relative to Dossier)
		   scenario:'scenario/scenario_test_moves.oz'
		   % Utilisez cette touche pour quitter la fenêtre
		   % Use this key to leave the graphical mode
		   closeKey:'Escape'
		   % Visualisation de la partie
		   % Graphical mode
		   debug: true
		   % Instants par seconde, 0 spécifie une exécution pas à pas. (appuyer sur 'Espace' fait avancer le jeu d'un pas)
		   % Steps per second, 0 for step by step. (press 'Space' to go one step further)
		   frameRate: 5
		)
   end

%%%%%%%%%%%
% The end %
%%%%%%%%%%%
   
   local 
      R = {LethOzLib.play Dossier#'/'#Options.scenario Next DecodeStrategy Options}
   in
      {Browse R}
   end
end


