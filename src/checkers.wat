(module
	(import "events" "piececrowned"
		(func $notify_piececrowned (param $pieceX i32) (param $pieceY i32))
	)
  (memory $mem 1)
  (global $WHITE i32 (i32.const 2))
  (global $BLACK i32 (i32.const 1))
  (global $CROWN i32 (i32.const 4))
  (global $currentTurn (mut i32) (i32.const 0))
  (func $indexForPosition (param $x i32) (param $y i32) (result i32)
    (i32.add
    	(i32.mul
    		(get_local $y)
    		(i32.const 8)
    	)
    	(get_local $x)
    )
  )
  ;;Offset = ( x + y * 8) * 4
  (func $offsetForPosition (param $x i32) (param $y i32) (result i32)
  	(i32.mul
  		(call $indexForPosition (get_local $x) (get_local $y))
  		(i32.const 4)
  	)
  )
  ;;Determine if a piece has been crowned
  (func $isCrowned (param $piece i32) (result i32)
  	(i32.eq
  		(i32.and (get_local $piece) (get_global $CROWN))
  		(get_global $CROWN)
  	)
  )
  ;;Determine if a piece is black
  (func $isBlack (param $piece i32) (result i32)
  	(i32.eq
  		(i32.and (get_local $piece) (get_global $BLACK))
  		(get_global $BLACK)
  	)
  )
  ;;Determine if a piece is white
  (func $isWhite (param $piece i32) (result i32)
  	(i32.eq
  		(i32.and (get_local $piece) (get_global $WHITE))
  		(get_global $WHITE)
  	)
  )
  ;;Add crown to a give piece
  (func $withCrown (param $piece i32) (result i32)
  	(i32.or (get_local $piece) (get_global $CROWN)) 
  )
  ;;Remove crown from a piece
  (func $withoutCrown (param $piece i32) (result i32)
  	(i32.and (get_local $piece) (i32.const 3))
  )
  ;;Sets a piece on the board
  (func $setPiece (param $x i32) (param $y i32) (param $piece i32)
  	(i32.store
  		(call $offsetForPosition (get_local $x) (get_local $y))
  		(get_local $piece)
  	)
  )
  ;;Gets a piece from the board
  (func $getPiece (param $x i32) (param $y i32) (result i32)
  	(if(result i32)
  		(block (result i32)
  			(i32.and
  				(call $inRange (i32.const 0) (i32.const 7) (get_local $x))
  				(call $inRange (i32.const 0) (i32.const 7) (get_local $y))
  			)
  		)
  		(then
  			(i32.load
  				(call $offsetForPosition (get_local $x) (get_local $y))
  			)
  		)
  		(else
  			(unreachable)
  		)
  	)
  )
  ;;Detect if values are within range (includive high and low)
  (func $inRange (param $lower i32) (param $upper i32) (param $value i32) (result i32)
  	(i32.and
  		(i32.ge_s (get_local $value) (get_local $lower))
  		(i32.le_s (get_local $value) (get_local $upper))
  	) 
  )
  ;;Get the current turn owner (white or black)
  (func $getTurnOwner (result i32)
  	(get_global $currentTurn)
  )

  ;;At the end of a turn, switch turn owner to the other player
  (func $toggleTurnOwner
  	(set_global $currentTurn 
  		(i32.xor
  			(i32.const 3)
  			(get_global $currentTurn)
  		)
  	)
  )
  ;;Set the turn over, e.g. at game start
  (func $setTurnOwner (param $piece i32)
  	(set_global $currentTurn (get_local $piece))
  )
  ;;should this piece be crowned?
  ;; We crown black pieces in row 0, white pieces in row 7
  (func $shouldCrown (param $ypos i32) (param $piece i32) (result i32)
  	(i32.or
	  	(i32.and
	  		(call $isWhite (get_local $piece))
	  		(i32.eq (get_local $ypos) (i32.const 7))
	  	)
	  	(i32.and
	  		(call $isBlack (get_local $piece))
	  		(i32.eq (get_local $ypos) (i32.const 0))
	  	)
	  )
  )
  ;; Converts a piece into a crowned piece and invokes a host notifier
  (func $crownPiece (param $x i32) (param $y i32)
  	(local $piece i32)
  	(set_local $piece (call $getPiece (get_local $x) (get_local $y)))
  	(call $setPiece (get_local $x) (get_local $y) (call $withCrown (get_local $piece)))
  	(call $notify_piececrowned (get_local $x) (get_local $y))
  )

  (func $distance (param $x i32) (param $y i32) (result i32)
  	(i32.sub (get_local $x) (get_local $y))
  )
  
  (export "setTurnOwner" (func $setTurnOwner))
  (export "getTurnOwner" (func $getTurnOwner))
  (export "toggleTurnOwner" (func $toggleTurnOwner))
  (export "setPiece" (func $setPiece))
  (export "getPiece" (func $getPiece))
  (export "offsetForPosition" (func $offsetForPosition))
  (export "isCrowned" (func $isCrowned))
  (export "isWhite" (func $isWhite))
  (export "isBlack" (func $isBlack))
  (export "withCrown" (func $withCrown))
  (export "withoutCrown" (func $withoutCrown))
)  