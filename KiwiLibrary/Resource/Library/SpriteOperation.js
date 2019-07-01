/*
 * Node.js
 */

class SpriteNodeOperation extends Operation
{
        constructor(){
                super() ;
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
                let position = status.position ;
                let size     = status.size ;
                let energy   = status.energy ;
                checkVariables("SpriteNodeOperation.status (get)", status, position, size, energy) ;
                return new SpriteNodeStatus(position, size, energy) ;
        }
        set status(newstat){ // SpriteNodeStatus
                if(checkVariables("SpriteNodeOperation.status (set)", newstat, newstat.position, newstat.size, newstat.energy)){
                        let status = {
                                position: newstat.position,
                                size:     newstat.size,
                                energy:   newstat.energy
                        } ;
                        super.setParameter("status", status) ;
                }
        }

	// condition: SpriteCondition
	get conditions() {
		let cond    = super.parameter("conditions") ;
		let cdamage = cond.collisionDamage ;
		checkVariables("SpriteNodeOperation.conditions (get)", cond, cdamage) ;
		return new SpriteCondition(cdamage) ;
	}
	set conditions(newcond) {
		 if(checkVariables("SpriteNodeOperation.conditions (set)", newcond, newcond.collisionDamage)){
			 let cond = {
			 	collisionDamage: newcond.collisionDamage
			 } ;
			 super.setParameter("conditions", cond) ;
		 }
	}

	execute(){
                let status  = this.status ;
                let action  = this.action ;
                let newact  = this.decideAction(status, action) ;
                this.result = newact ;
        }

        // decideAction(status: Status, action: Action)
        decideAction(status, action){
                console.log("[Error] SpriteNodeOperation.decideAction\n") ;
                return action ;
        }
}
