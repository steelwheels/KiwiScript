/*
 * Curses.js
 */

class CFrame
{
        // constructor(frame: Rect)
	constructor(frame){
                this.mFrame             = frame ;
                this.mForegroundColor   = Curses.foregroundColor ;
                this.mBackgroundColor   = Curses.backgroundColor ;
	}

        // foregroundColor: Int
        get foregroundColor()       { return this.mForegroundColor ;    }
        set foregroundColor(newcol) { this.mForegroundColor = newcol ;  }

        // backgroundColor: Int
        get backgroundColor()       { return this.mBackgroundColor ;    }
        set backgroundColor(newcol) { this.mBackgroundColor = newcol ;  }

        // fill(pat: Character)
        fill(pat){
                const x         = this.mFrame.x ;
                const y         = this.mFrame.y ;
                const width     = this.mFrame.width ;
                const height    = this.mFrame.height ; 
                Curses.fill(x, y, width, height, pat) ;
        }
}
