package ssma.sminv.printing

import ssma.fml.printing.FmlDslPrinter
import ssma.sminv.sminvDsl.NegFml
import ssma.sminv.sminvDsl.Compound
import ssma.sminv.sminvDsl.BoolConstant
import ssma.sminv.sminvDsl.IntConstant
import ssma.sminv.sminvDsl.VarRef

class SminvDslPrinter extends FmlDslPrinter{
	
	//TODO: this is quite cumbersome since the representation 
	//    from super must here repeated literally the same
	//    This will hopefully much more elegant in xtext 2.9
		override String stringRepr(ssma.fml.fmlDsl.Term t) {
			switch (t) {
			NegFml:
			'''(!«t.t.stringRepr»)'''
			Compound:
			'''«t.t.stringRepr»'''  //since we have already () around every subterm
			BoolConstant: '''«t.value»'''
			IntConstant: '''«t.value»'''
			VarRef:
			'''«t.v.name»'''
			default: super.stringRepr(t)
			}
		}
	
}