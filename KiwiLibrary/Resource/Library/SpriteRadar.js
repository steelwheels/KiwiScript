/* SpriteRange.js */

class SpriteNodeInfo
{
	// constructor(name: String, teamid: Int, position: Point)
	constructor(name, teamid, position){
		this.mName 	= name ;
		this.mTeamId 	= teamid ;
		this.mPoisition	= position ;
	}

	get name()     { return this.mName ; 		}
	get teamId()   { return this.mTeamId ;		}
	get position() { return this.mPoisition ;	}
}

class SpriteRadar
{
	constructor(){
		this.nodes = [] ;
	}

	addNodeInfo(name, teamid, position){
		if(checkVariables("SpriteRadar.addNode", name, teamid, position)) {
			let ninfo = new SpriteNodeInfo(name, teamid, position) ;
			this.nodes.push(ninfo) ;
		}
	}
}
