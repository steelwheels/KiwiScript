/*
 * turtle.js: Support Turtle Graphics
 */

class Turtle {
    // The context "ctxt" is given by Graphic2D component
    constructor(ctxt, x, y){
        this.mContext            = ctxt ;
        this.mCurrentX           = x ;
        this.mCurrentY           = y ;
        this.mCurrentAngle	     = 0 ;
        this.mMovingAngle        = Math.PI / 2.0 ;
        this.mMovingDistance     = ctxt.logicalFrame.width / 10.0 ;
        this.mHistory            = [] ;

        ctxt.moveTo(this.currentX, this.currentY) ;
    }

    get currentX()              { return this.mCurrentX ;         }
    get currentY()              { return this.mCurrentY ;         }
    get currentAngle()          { return this.mCurrentAngle ;     }

    get movingAngle()           { return this.mMovingAngle ;      }
    set movingAngle(newval)     { this.mMovingAngle = newval ;    }
    get movingDistance()        { return this.mMovingDistance ;   }
    set movingDistance(newval)  { this.mMovingDistance = newval ; }

    forward(dodraw) {
        this.mCurrentX += Math.sin(this.mCurrentAngle) * this.mMovingDistance ;
        this.mCurrentY += Math.cos(this.mCurrentAngle) * this.mMovingDistance ;
        if(dodraw) {
            this.mContext.lineTo(this.mCurrentX, this.mCurrentY) ;
        } else {
            this.mContext.moveTo(this.mCurrentX, this.mCurrentY) ;
        }
    }

    turn(doright) {
        if(doright){
            this.mCurrentAngle += this.mMovingAngle ;
        } else {
            this.mCurrentAngle -= this.mMovingAngle ;
        }
    }

    push() {
        let obj = {
            x:          this.mCurrentX,
            y:          this.mCurrentY,
            angle:      this.mCurrentAngle
        }
        this.mHistory.push(obj) ;
    }

    pop() {
        let ret = this.mHistory.pop() ;
        if(!isUndefined(ret)) {
            if(!isUndefined(ret.x)) {
                this.mCurrentX = ret.x ;
            } else {
                console.error("[Error] No X property in Turtle\n") ;
            }
            if(!isUndefined(ret.y)) {
                this.mCurrentY = ret.y ;
            } else {
                console.error("[Error] No Y property in Turtle\n") ;
            }
            if(!isUndefined(ret.angle)) {
                this.mCurrentAngle = ret.angle ;
            } else {
                console.error("[Error] No angle property in Turtle\n") ;
            }
        } else {
            console.error("[Error] No history in Turtle\n") ;
        }
    }

    exec(commands) { /* commands: String */
        let cmdlen = commands.length ;
        for(let i=0 ; i<cmdlen ; i++){
            let cmd = commands.charAt(i) ;
            switch(cmd){
                case "F":
                    this.forward(true) ;
                break ;
                case "f":
                    this.forward(false) ;
                break ;
                case "+":
                    this.turn(true) ;
                break ;
                case "-":
                    this.turn(false) ;
                break ;
                case "[":
                    this.push() ;
                break ;
                case "]":
                    this.pop() ;
                break ;
                default:
                    console.error(`[Error] Unknown turtle command: ${cmd}\n`) ;
                break ;
            }
        }
    }
} ;
