package ssma.sminv.printing

import ssma.fml.fmlDsl.AndFml
import ssma.fml.fmlDsl.CompareFml
import ssma.fml.fmlDsl.OrFml
import ssma.fml.fmlDsl.Term
import ssma.sminv.sminvDsl.VarRef

import static extension org.eclipse.xtext.EcoreUtil2.*

/**
 * Prints an input file for the prover PRINCESS
 */
class SminvDslPrincessPrinter extends SminvDslPrinter {

	def String princessRepr(Term t) {
		val occurringVarNamesInT = t.getAllContentsOfType(typeof(VarRef)).map[v.name].toSet
		// computation of prefix
		var prefix = ''''''
		if (!occurringVarNamesInT.isEmpty) {
			prefix = prefix + '''\universalConstants { '''
			for (String varname : occurringVarNamesInT) {
				prefix = prefix + ''' int «varname»;'''
			}
			prefix = prefix + "}"
		}
		// computation of problem
		val problem = ''' \problem{ «t.stringRepr» }'''
		// return the result
		prefix + problem
	}

	// for Princess, we have to override some of the normal representation, but overall
	// it looks quite similar
	override String stringRepr(Term t) {
		switch (t) {
			AndFml: '''(«t.left.stringRepr» & «t.right.stringRepr»)'''
			OrFml: '''(«t.left.stringRepr» | «t.right.stringRepr»)'''
			CompareFml: '''(«t.left.stringRepr» «princessTransformCompareOp(t.op)» «t.right.stringRepr»)'''
			default:
				super.stringRepr(t)
		}
	}

	private def princessTransformCompareOp(String op) {
		if (op.equals('=='))
			'='
		else
			op
	}

}