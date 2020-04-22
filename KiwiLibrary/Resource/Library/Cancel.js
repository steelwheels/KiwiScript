class CancelException extends Error
{
        constructor (code){
                super("CancelException") ;
                this.code = code ;
        }
}

function _cancel() {
	throw new CancelException(ExitCode.exception) ;
}

