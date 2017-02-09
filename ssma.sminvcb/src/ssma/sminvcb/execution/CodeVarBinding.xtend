package ssma.sminvcb.execution

import ssma.sminv.eval.Binding
import ssma.sminvcb.adapter.IAppAdapter
import ssma.sminv.sminvDsl.Var

import static extension ssma.sminvcb.util.SminvcbDslUtil.*

class CodeVarBinding extends Binding{
	
	var IAppAdapter adapter
	var Binding noneCodeVarBinding
	
	new(IAppAdapter ad, Binding binding) {
		super()
		adapter=ad
		noneCodeVarBinding=binding
	}
	
	override int getVal(Var v){
		if (v.isCodeVar)
			return adapter.getVal(v.name)
		else
			return noneCodeVarBinding.getVal(v)	
	}
	
}