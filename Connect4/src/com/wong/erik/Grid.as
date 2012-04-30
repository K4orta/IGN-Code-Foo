package com.wong.erik 
{
	import flash.geom.Point;
	import JSON;
	/**
	 * ...
	 * @author Erik
	 */
	
	 
	public class Grid {
		protected var _gridWidth:int = 7;
		protected var _gridHeight:int = 6;
		public var grid:Array;
		
		public function Grid() {
			// Set up a 2D Array to hold the tokens 
			reset();
		}
		
		//___________________________________________________________
		//——————————————————————————————————————————————————— METHODS
		
		public function reset():void {
			grid = new Array(_gridHeight);
			for (var i:int = 0; i < grid.length;++i ) {
				grid[i] = new Array(_gridWidth);
				for (var j:int = 0; j < grid[i].length;++j ) {
					grid[i][j] = 0;
				}
			}
		}
		
		public function placeMove(X:int, TokenOwner:int):Point {
			var i:int = 0;
			while(i<_gridHeight){
				if (i+1>=_gridHeight || grid[i + 1][X] != 0) {
					grid[i][X] = TokenOwner;
					return new Point(X,i);
				}else {
					++i;
				}
			}
			return null;
			//trace(JSON.stringify(grid));
		}
		
		public function findOpenMoves():Vector.<int> {
			var open:Vector.<int> = new Vector.<int>();
			for (var j:int = 0; j < _gridWidth;++j ) {
				if (grid[0][j]==0) {
					open.push(j);
				}
			}
			return open;
		}
		
		public function anyOpenMoves():Boolean {
			for (var j:int = 0; j < _gridWidth;++j ) {
				if (grid[0][j]==0) {
					return true;
				}
			}
			return false;
		}
		
		public function checkVictory():Object {
			var chk:Object =0;
			for (var i:int = 0; i < _gridHeight;++i ) {
				for (var j:int = 0; j < _gridWidth;++j ) {
					chk = connected(j, i);
					if (chk) {
						return chk;
					}
				}
			}
			return null;
		}
		
		// Checks to see if a square is connected, if it is return an object with information about the winning pieces 
		public function connected(X:int, Y:int, Connections:int=1, Direction:Point=null):Object {
			//If we've connected four, the game is over
			if (Connections == 4) {
				return { "x":X, "y":Y, "dir":Direction, "winner":grid[Y-Direction.y][X-Direction.x] };// ;	
			}
			if (grid[Y][X]==0){ 
				return null;
			}
			
			// If we have a direction, keep checking that way
			if (Direction) {
				// make sure the next check is in bounds
				if (X + Direction.x >= 0 && X + Direction.x < _gridWidth && Y + Direction.y >= 0 && Y + Direction.y < _gridHeight) {
					if (grid[Y][X] == grid[Y + Direction.y][X + Direction.x]) {
						return connected(X + Direction.x, Y + Direction.y, Connections + 1, Direction);
					}
				}
			}else{
				//If no Direction, check surrounding squares
				for (var i:int = -1;i<=1;++i ) {
					for (var j:int = -1; j <= 1;++j ) {
						// ignore this square
						if (i == 0 && j == 0)
							continue;
						// make sure the next check is in bounds
						if(X+j>=0&&X+j<_gridWidth&&Y+i>=0&&Y+i<_gridHeight){
							if (grid[Y][X] == grid[Y + i][X + j]) {
								return connected(X + j, Y + i, Connections+1,new Point(j,i));
							}
						}
					}
				}
			}
			return null;
		}
		
		//___________________________________________________________
		//————————————————————————————————————————— GETTERS / SETTERS
		
		public function get gridWidth():int { return _gridWidth; }
		public function get gridHeight():int { return _gridHeight; }
	}

}