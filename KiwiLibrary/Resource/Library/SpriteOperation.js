/*
 * Node.js
 */

class SpriteNodeOperation extends Operation
{
        constructor(){
                super() ;
        }

	get interval(){
		let interval = super.parameter("interval") ;
		checkVariables("SpriteNodeOperation.interval (get)", interval) ;
		return interval ;
	}

        // action: SpriteNodeAction
        get action() {
                let action  = super.parameter("action") ;
                let speed   = action.speed ;
                let angle   = action.angle ;
                checkVariables("SpriteNodeOperation.action (get)", action, speed, action) ;
                return new SpriteNodeAction(speed, angle) ;
        }
        set action(newact){ // SpriteNodeAction
                if(checkVariables("SpriteNodeOperation.action (set)", newact, newact.speed, newact.angle)){
                        let action = {
                                speed:   newact.speed,
                                angle:   newact.angle
                        } ;
                        super.setParameter("action", action) ;
                }
        }

        // result: SpriteNodeAction
        get result() {
                let action  = super.parameter("result") ;
                let speed   = action.speed ;
                let angle   = action.angle ;
                checkVariables("SpriteNodeOperation.result (get)", action, speed, action) ;
                return new SpriteNodeAction(speed, angle) ;
        }
        set result(newact){ // SpriteNodeAction
                if(checkVariables("SpriteNodeOperation.result (set)", newact, newact.speed, newact.angle)){
                        let action = {
                                speed:   newact.speed,
                                angle:   newact.angle
                        } ;
                        super.setParameter("result", action) ;
                }
        }

        // status: SpriteNodeStatus
        get status() {
                let status   = super.parameter("status") ;
		let name     = status.name ;
		let teamid   = status.teamId ;
                let position = status.position ;
                let size     = status.size ;
		let bounds   = status.bounds ;
                let energy   = status.energy ;
                checkVariables("SpriteNodeOperation.status (get)", name, teamid, status, position, size, bounds, energy) ;
                return new SpriteNodeStatus(name, teamid, position, size, bounds, energy) ;
        }
        set status(newstat){ // SpriteNodeStatus
                if(checkVariables("SpriteNodeOperation.status (set)", newstat, newstat.name, newstat.teamId, newstat.position, newstat.size, newstat.bounds, newstat.energy)){
                        let status = {
                                name:     newstat.name,
                                teamId:   newstat.teamId,
                                position: newstat.position,
                                size:     newstat.size,
                                bounds:	  newstat.bounds,
                                energy:   newstat.energy
                        } ;
                        super.setParameter("status", status) ;
                }
        }

	// condition: SpriteCondition
	get conditions() {
		let cond     = super.parameter("conditions") ;
		let gcdamage = cond.givingCollisionDamage ;
		let rcdamage = cond.receivingCollisionDamage ;
		let rrange   = cond.raderRange ;
		checkVariables("SpriteNodeOperation.conditions (get)", cond, gcdamage, rcdamage, rrange) ;
		return new SpriteCondition(gcdamage, rcdamage, rrange) ;
	}
	set conditions(newcond) {
                if(checkVariables("SpriteNodeOperation.conditions (set)", newcond, newcond.givingCollisionDamage, newcond.receivingCollisionDamage, newcond.raderRange)){
                         let cond = {
			 	givingCollisionDamage:		newcond.givingCollisionDamage,
			 	receivingCollisionDamage:	newcond.receivingCollisionDamage,
			 	raderRange:			newcond.raderRange
                         } ;
                        super.setParameter("conditions", cond) ;
                }
	}

	// radar: SpriteRadar
	get radar() {
		let rinfo  = super.parameter("radar") ;
		let result = new SpriteRadar() ;
		if(rinfo.isArray){
			for(var ninfo of rinfo){
				let name   = ninfo.name ;
				let teamid = ninfo.teamId ;
				let pos    = ninfo.position ;
				result.addNodeInfo(name, teamid, pos) ;
			}
		} else {
			console.error("[Error] SpriteNodeOperation.radar.get: Not array") ;
		}
		return result ;
	}


	execute(){
                let status   = this.status ;
                let interval = this.interval ;
                let action   = this.action ;
                let newact   = this.decideAction(interval, status, action) ;
                this.result  = newact ;
        }

	// decideAction(interval:TimeInterval, status: Status, action: Action)
        decideAction(interval, status, action){
                console.log("[Error] SpriteNodeOperation.decideAction\n") ;
                return action ;
        }
}
