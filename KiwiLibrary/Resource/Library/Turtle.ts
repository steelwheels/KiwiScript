/*
 * turtle.ts: Support Turtle Graphics
 */

/// <reference path="types/Builtin.d.ts"/>

type TurtleStatus = {
        x:          number ;
        y:          number ;
        angle:      number ;
} ;

class Turtle
{
	mContext:	        GraphicsContextIF ;
	mCurrentX:	        number ;
	mCurrentY:	        number ;
	mCurrentAngle:	        number ;
	mMovingAngle:	        number ;
        mMovingDistance:        number ;
	mPenSize:	        number ;
        mHistory:               TurtleStatus[] ;

        constructor(ctxt: GraphicsContextIF){
                this.mContext		= ctxt ;
                this.mCurrentX		= 0.0 ;
                this.mCurrentY		= 0.0 ;
                this.mCurrentAngle	= 0 ;
                this.mMovingAngle	= Math.PI / 2.0 ;
                this.mMovingDistance	= ctxt.logicalFrame.width / 10.0 ;
	        this.mPenSize		= this.mMovingDistance / 10.0 ;
                this.mHistory		= [] ;
        }

        setup(x:number, y:number, angle:number, pen: number): void {
                this.mCurrentX      = x ;
                this.mCurrentY      = y ;
                this.mCurrentAngle  = angle ;
                this.mPenSize       = pen ;

                this.mContext.moveTo(x, y) ;
                this.mContext.setPenSize(pen) ;
        }

        get logicalFrame(): RectIF              { return this.mContext.logicalFrame ; }

        get currentX(): number                  { return this.mCurrentX ;         }
        get currentY(): number                  { return this.mCurrentY ;         }
        get currentAngle(): number              { return this.mCurrentAngle ;     }

        get movingAngle(): number               { return this.mMovingAngle ;      }
        set movingAngle(newval: number)         { this.mMovingAngle = newval ;    }
        get movingDistance(): number            { return this.mMovingDistance ;   }
        set movingDistance(newval: number)      { this.mMovingDistance = newval ; }

        get penSize(): number                   { return this.mPenSize ;          }
        set penSize(newval: number)  {
	        this.mContext.setPenSize(newval) ;
	        this.mPenSize = newval ;
        }

        forward(dodraw: boolean): void {
                this.mCurrentX += Math.sin(this.mCurrentAngle) * this.mMovingDistance ;
                this.mCurrentY += Math.cos(this.mCurrentAngle) * this.mMovingDistance ;
                if(dodraw) {
                        this.mContext.lineTo(this.mCurrentX, this.mCurrentY) ;
                } else {
                        this.mContext.moveTo(this.mCurrentX, this.mCurrentY) ;
                }
        }

        turn(doright: boolean): void {
                if(doright){
                        this.mCurrentAngle += this.mMovingAngle ;
                } else {
                        this.mCurrentAngle -= this.mMovingAngle ;
                }
        }

        push() {
                let obj: TurtleStatus = {
                  x:          this.mCurrentX,
                  y:          this.mCurrentY,
                  angle:      this.mCurrentAngle
                } ;
                this.mHistory.push(obj) ;
        }

        pop(): void {
                let ret = this.mHistory.pop() ;
                if(!isUndefined(ret)) {
			let stat: TurtleStatus = ret! ; // Cast force

                        if(!isUndefined(stat.x)) {
                                this.mCurrentX = stat.x ;
                        } else {
                                console.error("[Error] No X property in Turtle\n") ;
                        }
                        if(!isUndefined(stat.y)) {
                                this.mCurrentY = stat.y ;
                        } else {
                                console.error("[Error] No Y property in Turtle\n") ;
                        }
                        if(!isUndefined(stat.angle)) {
                                this.mCurrentAngle = stat.angle ;
                        } else {
                                console.error("[Error] No angle property in Turtle\n") ;
                        }
	                /* Update current position */
	                this.mContext.moveTo(this.mCurrentX, this.mCurrentY) ;
                } else {
                        console.error("[Error] No history in Turtle\n") ;
                }
        }

        exec(commands: string) {
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
}
