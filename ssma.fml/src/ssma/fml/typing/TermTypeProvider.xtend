package ssma.fml.typing

import ssma.fml.fmlDsl.AndFml
import ssma.fml.fmlDsl.BoolConstant
import ssma.fml.fmlDsl.CompareFml
import ssma.fml.fmlDsl.Compound
import ssma.fml.fmlDsl.EquivFml
import ssma.fml.fmlDsl.ImpliesFml
import ssma.fml.fmlDsl.IntConstant
import ssma.fml.fmlDsl.MultDiv
import ssma.fml.fmlDsl.NegFml
import ssma.fml.fmlDsl.OrFml
import ssma.fml.fmlDsl.PlusMinus
import ssma.fml.fmlDsl.Term

class TermTypeProvider {
	public static val intType = new IntType
	public static val boolType = new BoolType

	def TermType typeFor(Term e) {
		switch (e) {
			EquivFml: boolType
			ImpliesFml: boolType
			OrFml: boolType
			AndFml: boolType
			CompareFml: boolType
			NegFml: boolType
			BoolConstant: boolType
			PlusMinus: intType
			MultDiv: intType
			IntConstant: intType
			Compound: e.t.typeFor
		}
	}

	def isInt(TermType type) { type == intType }

	def isBoolean(TermType type) { type == boolType }

}