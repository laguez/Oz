local
   NoBomb=false|NoBomb
in
   scenario(bombLatency:3
	    walls:true
	    step: 0
	    spaceships: [
		     spaceship(team:peru name:gordon
			   positions: [pos(x:6 y:6 to:east) pos(x:5 y:6 to:east) pos(x:4 y:6 to:east) pos(x:3 y:6 to:east)]
			   effects: nil
			   strategy: [random(forward|turn(left)|turn(right)|forward|nil) random(forward|forward|turn(right)|turn(right)|nil) 
			   repeat([forward repeat([turn(right)] times:4)] times:2) random(forward|turn(left)|turn(right)|forward|turn(left)|forward|nil) forward 
			   random(turn(right)|turn(left)|forward|turn(right)|nil)]
			   seismicCharge: NoBomb
			  )
		     spaceship(team:green name:steve
			 positions: [pos(x:14 y:14 to:west) pos(x:15 y:14 to:west) pos(x:16 y:14 to:west) pos(x:17 y:14 to:west)]
			 effects: nil
			   strategy: [forward turn(right) turn(right) random(turn(left)|turn(right)|forward|forward|nil) turn(right) forward forward forward turn(right) turn(right) turn(left)
				      repeat([forward] times:3) random(turn(right)|turn(left)|forward|turn(left)|forward|turn(right)|forward|turn(left)|nil) repeat([turn(right)] times:3)]
			   seismicCharge: true|NoBomb
			  )
			spaceship(team:snow name:patrick
			positions: [pos(x:19 y:20 to:west) pos(x:20 y:20 to:west) pos(x:21 y:20 to:west)]
			effects: nil
			   strategy: [turn(left) random(turn(right)|turn(left)|turn(left)|forward|forward|forward|turn(left)|nil) repeat([forward] times:3) repeat([turn(left) repeat([turn(right)] times:2)] times:3) random(forward|turn(left)|turn(right)|nil) random(forward|forward|turn(right)|turn(left)|nil)]
			   seismicCharge: NoBomb
			  )
		     spaceship(team:red name:john
			   positions: [pos(x:9 y:5 to:south) pos(x:9 y:4 to:south) pos(x:10 y:4 to:west) pos(x:11 y:4 to:west) pos(x:12 y:4 to:west)]
			   effects: nil
			   strategy: [random(turn(left)|forward|turn(left)|turn(right)|forward|nil) forward forward repeat([turn(left)
							      repeat([forward]
								     times:2)
							     ]
							     times:5)
				     ]
			   seismicCharge: NoBomb
			  )
		    ]
          bonuses: [
            % Wormholes in both directions
             bonus(position:pos(x:18 y:22)   color:yellow effect:wormhole(x:17 y:17) target:catcher)
             bonus(position:pos(x:17 y:17) color:yellow effect:wormhole(x:12 y:12) target:catcher)
 
            % Normal bonuses
             bonus(position:pos(x:11 y:11) color:red effect:revert target:catcher)
             bonus(position:pos(x:12 y:12) color:pink effect:scrap target:catcher)
			 bonus(position:pos(x:9 y:14) color:pink effect:scrap target:catcher)



            % Drop a seismic charge if the spaceship passes through the bonus
            bonus(position:pos(x:9 y:9)   color:black  effect:dropSeismicCharge(true|false|true|false|true|nil) target:catcher)
            bonus(position:pos(x:18 y:18) color:black  effect:dropSeismicCharge(true|false|true|false|true|nil) target:catcher)
            
            % Extension effects
            bonus(position:pos(x:15 y:3) color:blue effect:minus target:catcher)
            bonus(position:pos(x:20 y:5) color:blue effect:minus target:catcher)
            ]
        bombs: [
         bomb(position:pos(x:15 y:12) explodesIn:3)
         bomb(position:pos(x:9 y:8) explodesIn:3)
         bomb(position:pos(x:20 y:8) explodesIn:2)
        ]
      )
         
end 