package ssma.sminvcb.printing

import ssma.sminvcb.sminvcbDsl.SminvcbModel

class SminvcbDslPrinter {
	
	def String stringRepr(SminvcbModel m) {
		'''
		project name is «m.name»  and adapter class is «m.facn»
		
		This codebridge is based on model «m.sminvModel.name» which has «m.sminvModel.vd.vars.size» many var-declarations 
		'''
	}
	
	
}