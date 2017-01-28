package ssma.sminvcb.execution

import ssma.sminv.eval.Binding
import ssma.sminvcb.adapter.IAppAdapter
import ssma.sminv.sminvDsl.Var

class CodeVarBinding  extends Binding{
	
	var IAppAdapter adapter
	
	new(IAppAdapter ad) {
		super()
		adapter=ad
	}
	
	override int getVal(Var v){
		adapter.getVal(v.name)
	}
	
}