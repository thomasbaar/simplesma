package ssma.fml.printing

import ssma.fml.fmlDsl.Term
import ssma.fml.fmlDsl.EquivFml
import ssma.fml.fmlDsl.ImpliesFml
import ssma.fml.fmlDsl.OrFml
import ssma.fml.fmlDsl.AndFml
import ssma.fml.fmlDsl.CompareFml
import ssma.fml.fmlDsl.PlusMinus
import ssma.fml.fmlDsl.MultDiv
import ssma.fml.fmlDsl.NegFml
import ssma.fml.fmlDsl.Compound
import ssma.fml.fmlDsl.BoolConstant
import ssma.fml.fmlDsl.IntConstant

class FmlDslPrinter {

	def String stringRepr(Term t) {
		switch (t) {
			EquivFml: '''(«t.left.stringRepr» <-> «t.right.stringRepr»)'''
			ImpliesFml: '''(«t.left.stringRepr» -> «t.right.stringRepr»)'''
			OrFml: '''(«t.left.stringRepr» || «t.right.stringRepr»)'''
			AndFml: '''(«t.left.stringRepr» && «t.right.stringRepr»)'''
			CompareFml: '''(«t.left.stringRepr» «t.op» «t.right.stringRepr»)'''
			PlusMinus: '''(«t.left.stringRepr» «t.op» «t.right.stringRepr»)'''
			MultDiv: '''(«t.left.stringRepr» «t.op» «t.right.stringRepr»)'''
			NegFml: '''(!«t.t.stringRepr»)'''
			Compound: '''«t.t.stringRepr»''' // since we have already () around every subterm
			BoolConstant: '''«t.value»'''
			IntConstant: '''«t.value»'''
		}
	}

}
