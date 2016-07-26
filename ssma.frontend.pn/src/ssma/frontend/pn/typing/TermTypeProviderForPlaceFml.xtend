package ssma.frontend.pn.typing

import ssma.fml.typing.TermTypeProvider
import ssma.fml.typing.TermType
import ssma.frontend.pn.pnDsl.PlaceFml
import ssma.frontend.pn.pnDsl.NegFml
import ssma.frontend.pn.pnDsl.Compound
import ssma.frontend.pn.pnDsl.BoolConstant

class TermTypeProviderForPlaceFml extends TermTypeProvider {

	override TermType typeFor(ssma.fml.fmlDsl.Term e) {
		// we must handle all termtypes introduced in sminv
		// (though they have the same name as in super grammar fml)
		switch (e) {
			NegFml: boolType
			Compound: typeFor(e.t)
			BoolConstant: boolType
			PlaceFml: boolType
			default: super.typeFor(e)
		}
	}

}