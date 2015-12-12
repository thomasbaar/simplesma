package ssma.sminv.typing

import ssma.fml.typing.TermTypeProvider
import ssma.fml.typing.TermType
import ssma.sminv.sminvDsl.NegFml
import ssma.sminv.sminvDsl.Compound
import ssma.sminv.sminvDsl.BoolConstant
import ssma.sminv.sminvDsl.IntConstant
import ssma.sminv.sminvDsl.VarRef

class TermTypeProviderWithVar extends TermTypeProvider {

	override TermType typeFor(ssma.fml.fmlDsl.Term e) {
		// we must handle all termtypes introduced in sminv
		// (though they have the same name as in super grammar fml)
		switch (e) {
			NegFml: boolType
			BoolConstant: boolType
			IntConstant: intType
			Compound: e.t.typeFor
			VarRef: intType  // all variables are of type int
			default: super.typeFor(e)
		}
	}

}