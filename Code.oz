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
      declare 
         NoBomb=false|NoBomb
         Space = spaceship(
            positions:[pos(x:4 y:2 to:east)]
            effects:[dropSeismicCharge(true|false|true|nil) scrap  revert dropSeismicCharge(true|nil) scrap]
            strategy : nil 
            seismicCharge : NoBomb
         )

               
         Spaceship = spaceship(
            positions:[pos(x:4 y:3 to:south) pos(x:4 y:2 to:south) pos(x:4 y:1 to:east)]
           effects: [wormhole(x:10 y:1) wormhole(x:1 y:5) scrap revert]
           strategy : nil
           seismicCharge : NoBomb
         )

         FuriousSpaceship = spaceship(
            positions:[pos(x:4 y:1 to:west) pos(x:4 y:2 to:north) pos(x:4 y:3 to:north)]
            effects:[minus minus dropSeismicCharge(true|nil) scrap ] 
            strategy : [repeat([turn(right)] times:2)]
            seismicCharge : NoBomb
            )

         
          %La fonction renvoie les attributs de l'effet du spaceship
         % on considère que c'est l'effet minus qui est supprimé et ignorer dans le record effects du Spaceship 
         % spaceship ::=  spaceship(
         %               positions: [
         %                  pos(x:<P> y:<P> to:<direction>) % Head
         %                  ...
         %                  pos(x:<P> y:<P> to:<direction>) % Tail
         %               ]
         %               effects: [minus|dropSeismicCharge(true|nil)|minus|wormhole(x:X y:Y)|scrap|revert|wormhole(x:X y:Y)|scrap|dropSeismicCharge(H|T)... ...]
         %            )
         %  : output : 
         % Spaceship.effects ::= [dropSeismicCharge(true|nil)|wormhole(x:X y:Y)|scrap|revert|wormhole(x:X y:Y)|scrap|dropSeismicCharge(H|T)... ...]
         fun {DeleteMinus Spaceship} 
            fun {DeleteMinus Spaceship Effets} 
               case Effets 
               of nil then nil 
               [] H|T then 
                  case H 
                  of nil then nil 
                  [] minus then 
                     {DeleteMinus Spaceship T} 
                  else 
                     H|{DeleteMinus Spaceship T}
                  end 
               end 
            end 
         in 
            {DeleteMinus Spaceship Spaceship.effects} 
         end 

         {Browse {DeleteMinus FuriousSpaceship}}


         %La fonction renvoie les attributs de l'effet du spaceship
         % on considère que c'est l'effet dropSeismicCharge qui est supprimé et ignorer dans le record effects du Spaceship 
         % spaceship ::=  spaceship(
         %               positions: [
         %                  pos(x:<P> y:<P> to:<direction>) % Head
         %                  ...
         %                  pos(x:<P> y:<P> to:<direction>) % Tail
         %               ]
         %               effects: [dropSeismicCharge(true|nil)|wormhole(x:X y:Y)|scrap|revert|wormhole(x:X y:Y)|scrap|dropSeismicCharge(H|T)... ...]
         %            )
         %  : output : 
         % Spaceship.effects ::= [scrap|revert|scrap|dropSeismicCharge(H|T)... ...]
         fun {DeleteDrop Spaceship}
            fun {DeleteDrop Spaceship Effets}
               case Effets 
               of nil then nil 
               [] H|T then 
                  case H 
                  of nil then nil 
                  [] dropSeismicCharge(L) then 
                     {DeleteDrop Spaceship T}
                  else 
                     H|{DeleteDrop Spaceship T}
                  end 
               end 
            end
         in 
            {DeleteDrop Spaceship Spaceship.effects}
         end 

         %{Browse {DeleteDrop Space}}
            
         % La fonction renvoie les attributs de l'effet du spaceship
         % on considère que c'est l'effet wormhole qui est supprimé et ignorer dans le record effects du Spaceship % Spaceship.effects
         % spaceship ::=  spaceship(
         %               positions: [
         %                  pos(x:<P> y:<P> to:<direction>) % Head
         %                  ...
         %                  pos(x:<P> y:<P> to:<direction>) % Tail
         %               ]
         %               effects: [wormhole(x:X y:Y)|scrap|revert|wormhole(x:X y:Y)|scrap|dropSeismicCharge(H|T)... ...]
         %            )
         %  : output : 
         % Spaceship.effects ::= [scrap|revert|scrap|dropSeismicCharge(H|T)... ...]
         fun {DeleteWormhole Spaceship}
            fun{DeleteWormhole Spaceship Effets}
               case Effets
               of nil then nil 
               [] H|T then 
                  case H 
                  of nil then nil 
                  [] wormhole(x:X y:Y) then 
                     {DeleteWormhole Spaceship T}
                  else 
                     H|{DeleteWormhole Spaceship T}
                  end 
               end 
            end 
         in   
            {DeleteWormhole Spaceship Spaceship.effects}
         end 

         %{Browse {DeleteWormhole Spaceship}}

         % La fonction renvoie les attributs de l'effet du spaceship
         % on considère que c'est l'effet scrap qui est supprimé et ignorer dans le record effects du Spaceship % Spacehip.effects
         % :input:
         % spaceship ::=  spaceship(
         %               positions: [
         %                  pos(x:<P> y:<P> to:<direction>) % Head
         %                  ...
         %                  pos(x:<P> y:<P> to:<direction>) % Tail
         %               ]
         %               effects: [scrap|wormhole(x:X y:Y)|scrap|revert|wormhole(x:X y:Y)|scrap|dropSeismicCharge(H|T)... ...]
         %            )
         % :output: 
         % Spaceship.effects ::= [wormhole(x:X y:Y)|revert|wormhole(x:X y:Y)|dropSeismicCharge(H|T)... ...]
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

         % La fonction renvoie les attributs de l'effet du spaceship
         % on considère que c'est l'effet scrap qui est supprimé et ignorer dans le record effects du Spaceship % Spacehip.effects
         % :input:
         % Spaceship ::=  spaceship(
         %               positions: [
         %                  pos(x:<P> y:<P> to:<direction>) % Head
         %                  ...
         %                  pos(x:<P> y:<P> to:<direction>) % Tail
         %               ]
         %               effects: [revert|wormhole(x:X y:Y)|scrap|revert|wormhole(x:X y:Y)|scrap|dropSeismicCharge(H|T)... ...]
         %            )
         % :output: 
         % Spaceship.effects ::= [wormhole(x:X y:Y)|revert|wormhole(x:X y:Y)|dropSeismicCharge(H|T)... ...]
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

         fun {Minus Spaceship} 
            fun {Minus Spaceship Positions}  
               case Positions 
               of nil then nil 
               [] H|T then 
                  if {Length T} == 1 then 
                     H|nil 
                  else 
                     H|{Minus Spaceship T}
                  end 
               end
            end 
         in 
            {Minus Spaceship Spaceship.positions}
         end 

         {Browse {Minus FuriousSpaceship}}


         % La fonction ajoute un élément à la queue de l'astronef en fonction de la direction et des coordonnées du dernière élément du vaisseau
         %:input:
         % Spaceship ::=  spaceship(
         %               positions: [
         %                  pos(x:<P> y:<P> to:<direction>) % Head
         %                  ...
         %                  pos(x:<P> y:<P> to:<direction>) % Tail
         %               ]
         %               effects: [revert|wormhole(x:X y:Y)|scrap|revert|wormhole(x:X y:Y)|scrap|dropSeismicCharge(H|T)... ...]
         %            )
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

         % La fonction ajoute au record seismicCharge la bombe lorsque celle-ci rencontre l'effet dropSeismicCharge(H|T) 
         % ainsi la charge sismique du spaceship sera mise à jour
         %:input:
         % spaceship ::=  spaceship(
         %               positions: [
         %                  pos(x:<P> y:<P> to:<direction>) % Head
         %                  ...
         %                  pos(x:<P> y:<P> to:<direction>) % Tail
         %               ]
         %               effects: [dropSeismicCharge(H|T)|revert|wormhole(x:X y:Y)|scrap|revert|wormhole(x:X y:Y)|scrap|dropSeismicCharge(H|T)... ...]
         %               seismicCharge : NoBomb
         %            )
         %:output: 
         % Spaceship.seismicCharge := {Append dropSeismicCharge(H|T) Spaceship.seismicCharge}
         %
         fun {Bomber Spaceship}
            fun{Bomber Spaceship Charge Bam}
               case Charge 
               of dropSeismicCharge(L) then
                  if L == nil then 
                     Bam 
                  else 
                     L.1|{Bomber Spaceship dropSeismicCharge(L.2) Bam}
                  end
               end 
            end 
         in 
            {Bomber Spaceship Spaceship.effects.1 Spaceship.seismicCharge}
         end 

         %{Browse {Bomber Space}}
         
         % La fonction va inverser les positions du vaisseaux de telle manière à ce que la première élement soit le dernier et ainsi de suite tout en conservant la  direction  
         %:input: 
         % Spaceship ::=  spaceship(
         %               positions: [
         %                  pos(x:<P> y:<P> to:<direction>) % Head
         %                  ...
         %                  pos(x:<P> y:<P> to:<direction>) % Tail
         %               ]
         %               effects: [dropSeismicCharge(H|T)|revert|wormhole(x:X y:Y)|scrap|revert|wormhole(x:X y:Y)|scrap|dropSeismicCharge(H|T)... ...]
         %            )
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

         %R = {Reverse Spaceship}

         % Exécution de l'attribut revert qui va inverser les positions de telles sortes à ce que le première élement deviennt le dernière élement 
         % tout en inverser par la même occasion son orientation 
         % si east => west ; west => east
         %:input: 
         % Spaceship ::=  spaceship(
         %               positions: [
         %                  pos(x:<P> y:<P> to:<direction>) % Head
         %                  ...
         %                  pos(x:<P> y:<P> to:<direction>) % Tail
         %               ]
         %               effects: [revert|dropSeismicCharge(H|T)|revert|wormhole(x:X y:Y)|scrap|revert|wormhole(x:X y:Y)|scrap|dropSeismicCharge(H|T)... ...]
         %            )
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

         %{Browse FuriousSpaceship.strategy}

         % La fonction applique l'attribut wormhole(x:X y:Y) sur le spacehip en le téléportant avec wormhole.x et wormhole.y 
         % :input: 
         % Spaceship ::=  spaceship(
         %               positions: [
         %                  pos(x:<P> y:<P> to:<direction>) % Head
         %                  ...
         %                  pos(x:<P> y:<P> to:<direction>) % Tail
         %               ]
         %               effects: [dropSeismicCharge(H|T)|revert|wormhole(x:X y:Y)|scrap|revert|wormhole(x:X y:Y)|scrap|dropSeismicCharge(H|T)... ...]
         %            )
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

         % La fonction avance l'astronef vers l'avant  
         % Spaceship ::=  spaceship(
         %               positions: [
         %                  pos(x:<P> y:<P> to:<direction>) % Head
         %                  ...
         %                  pos(x:<P> y:<P> to:<direction>) % Tail
         %               ]
         %               effects: [dropSeismicCharge(H|T)|revert|wormhole(x:X y:Y)|scrap|revert|wormhole(x:X y:Y)|scrap|dropSeismicCharge(H|T)... ...]
         %            )
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

         % La fonction tourne vers la gauche le vaisseau 
         % Spaceship ::=  spaceship(
         %               positions: [
         %                  pos(x:<P> y:<P> to:<direction>) % Head
         %                  ...
         %                  pos(x:<P> y:<P> to:<direction>) % Tail
         %               ]
         %               effects: [dropSeismicCharge(H|T)|revert|wormhole(x:X y:Y)|scrap|revert|wormhole(x:X y:Y)|scrap|dropSeismicCharge(H|T)... ...]
         %            )
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

         % Le fonction va faire tourner vers la droite l'astronef 
         % Spaceship ::=  spaceship(
         %               positions: [
         %                  pos(x:<P> y:<P> to:<direction>) % Head
         %                  ...
         %                  pos(x:<P> y:<P> to:<direction>) % Tail
         %               ]
         %               effects: [dropSeismicCharge(H|T)|revert|wormhole(x:X y:Y)|scrap|revert|wormhole(x:X y:Y)|scrap|dropSeismicCharge(H|T)... ...]
         %            ) 
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

         % la fonction va répéter N times l'action dans la liste du repeat puis vérifier si il y'a bien un repeat imbrique ou non 
         % Strategy ::= repeat(<strategy> times:<integer>)
         % Exemple : 
         % : input :  repeat([forward repeat([turn(left)] times:4) times:3)
         % : output : [forward forward forward forward turn(left) turn(left) turn(left) turn(left)]
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

         % {Browse {Repeat FuriousSpaceship.strategy.1}}


         % La fonction va modifié les arguments du spaceship en fonction de la tête de la liste Spaceship.effects 
         % Spaceship ::=  spaceship(
         %               positions: [
         %                  pos(x:<P> y:<P> to:<direction>) % Head
         %                  ...
         %                  pos(x:<P> y:<P> to:<direction>) % Tail
         %               ]
         %               effects: [dropSeismicCharge(H|T)|revert|wormhole(x:X y:Y)|scrap|revert|wormhole(x:X y:Y)|scrap|dropSeismicCharge(H|T)... ...]
         %            ) 
         % Instruction ::= turn(left) | turn(right) | forward
         fun {Effects Spaceship Instruction} 
            fun {Effects Spaceship Instruction Effets}
               local NewSpaceship in
                  case Effets 
                  of nil then % Si Spaceship.effetcs = nil alors on applique directement le déplacement en fonction l'argument :Instruction:
                     NewSpaceship = spaceship(positions:{Move Spaceship Instruction} effects:Effets) 
                  [] V|D then 
                     case V 
                     of nil then nil
                     [] dropSeismicCharge(L) then 
                        % Si la tête du Spaceship.effects = charge sismique alors on supprime et ignore tout les effets du même type tout ajoutant l effet dans les charges sismique du Spaceship en Head 
                        % Spaceship.seismicCharge ::=  L %Head | Spaceship.seismicCharge  %Tail 
                        NewSpaceship = spaceship(positions:Spaceship.positions effects:{DeleteDrop Spaceship} seismicCharge:{Bomber Spaceship})
                     [] scrap then
                        % Si la tête du Spaceship.effects = scrap alors on ajoute un wagon à la queue du vaisseau tout en supprimant et ignorant les effets du même types dans effetcs  
                        NewSpaceship = spaceship(positions:{Scrap Spaceship} effects:{DeleteScrap Spaceship} seismicCharge:Spaceship.seismicCharge) 
                     [] revert then 
                        % Si la tête du Spaceship.effects = revert alors on inverse le vaisseau complétement on inversant également l'orientation 
                        % Supprime et ignore le même types d'effets cad revert
                        NewSpaceship = spaceship(positions:{Revert Spaceship} effects:{DeleteRevert Spaceship} seismicCharge:Spaceship.seismicCharge)
                     [] wormhole(x:X y:Y) then 
                        % Si la tête du Spaceship.effects = wormhole(x:X y:Y) alors on teleporte l'ensemble du spaceship à la coordonnée du wormhole 
                        % Puis on supprime et ignore le même type d'effet dans effects cad wormhole(x:X y:Y)
                        NewSpaceship = spaceship(positions:{Worm Spaceship} effects:{DeleteWormhole Spaceship} seismicCharge:Spaceship.seismicCharge)
                     end 
                  end 
               end 
            end
         in 
            {Effects Spaceship Instruction Spaceship.effects}
         end    

         %HahaShip = {Effects Space turn(left)}
         %{Browse HahaShip.seismicCharge}


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
      %            
      fun {Next Spaceship Instruction}
         local ReturnSpaceship EffetShip in 
            EffetShip = {Effects Spaceship Instruction}
            case Spaceship.effects
            of nil then EffetShip
            [] V|D then 
               case V 
               of nil then nil 
               [] dropSeismicCharge(L) then 
                  ReturnSpaceship = spaceship(positions:{Move EffetShip Instruction} effects:EffetShip.effects seismicCharge:EffetShip.seismicCharge)
               [] scrap then 
                  ReturnSpaceship = spaceship(positions:{Move EffetShip Instruction} effects:EffetShip.effects seismicCharge:EffetShip.seismicCharge)
               [] revert then 
                  ReturnSpaceship = spaceship(positions:{Move EffetShip Instruction} effects:EffetShip.effects seismicCharge:EffetShip.seismicCharge) 
               [] wormhole(x:X y:Y) then
                  ReturnSpaceship = spaceship(positions:{Move EffetShip Instruction} effects:EffetShip.effects seismicCharge:EffetShip.seismicCharge) 
               end   
            end 
         end 
      end   
      
      %{Browse {Next Spaceship turn(right)}}

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
		   scenario:'scenario/scenario_crazy.oz'
		   % Utilisez cette touche pour quitter la fenêtre
		   % Use this key to leave the graphical mode
		   closeKey:'Escape'
		   % Visualisation de la partie
		   % Graphical mode
		   debug: true
		   % Instants par seconde, 0 spécifie une exécution pas à pas. (appuyer sur 'Espace' fait avancer le jeu d'un pas)
		   % Steps per second, 0 for step by step. (press 'Space' to go one step further)
		   frameRate: 0
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


