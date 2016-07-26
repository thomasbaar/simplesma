package ssma.frontend.pn.printing

import ssma.fml.printing.FmlDslPrinter
import ssma.frontend.pn.pnDsl.PlaceFml
import ssma.frontend.pn.pnDsl.NegFml
import ssma.frontend.pn.pnDsl.Compound
import ssma.frontend.pn.pnDsl.BoolConstant

class PnDslPrinter extends FmlDslPrinter{
	
		override String stringRepr(ssma.fml.fmlDsl.Term t) {
			switch (t) {
			NegFml:
			if (t.t instanceof PlaceFml){
				val PlaceFml pFml =  t.t as PlaceFml
				// non-marked place has 0 tokens on it
				'''«pFml.f.name» == 0'''
			}else{
			'''! («t.t.stringRepr()»)'''
			}
			Compound:
			'''(«t.t.stringRepr()»)'''
			BoolConstant:
			'''«t.value»'''
			PlaceFml:
			'''«t.f.name» == 1'''
			default: super.stringRepr(t)
			}
		}
	
}