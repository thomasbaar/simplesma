package ssma.sminv.eval

import ssma.fml.fmlDsl.AndFml
import ssma.fml.fmlDsl.CompareFml
import ssma.fml.fmlDsl.EquivFml
import ssma.fml.fmlDsl.ImpliesFml
import ssma.fml.fmlDsl.MultDiv
import ssma.fml.fmlDsl.OrFml
import ssma.fml.fmlDsl.PlusMinus
import ssma.fml.fmlDsl.Term
import ssma.sminv.sminvDsl.BoolConstant
import ssma.sminv.sminvDsl.Compound
import ssma.sminv.sminvDsl.IntConstant
import ssma.sminv.sminvDsl.NegFml
import ssma.sminv.sminvDsl.VarRef

class TermEvalProvider {
//	@Inject extension static TermTypeProviderWithVar
	
	
	def static boolean evalBool(Term e, Binding b){
		switch(e){
			NegFml : ! evalBool(e.t,b)
			ssma.fml.fmlDsl.NegFml: ! evalBool(e.t,b)
			BoolConstant : if (e.value.equals('true')){true}else{false}
			ssma.fml.fmlDsl.BoolConstant : if (e.value.equals('true')){true}else{false}
//			Compound: if(e.typeFor==TermTypeProvider.boolType){evalBool(e.t,b)}else{throw new IllegalStateException("wrong eval")}
//			ssma.fml.fmlDsl.Compound: if(e.typeFor==TermTypeProvider.boolType){evalBool(e.t,b)}else{throw new IllegalStateException("wrong eval")}
			Compound: evalBool(e.t,b)
			ssma.fml.fmlDsl.Compound: evalBool(e.t,b)
			EquivFml: evalBool(e.left,b) == evalBool(e.right,b)
			ImpliesFml: ( ! evalBool(e.left,b)) || evalBool(e.right,b)
			OrFml: evalBool(e.left,b) || evalBool(e.right,b)
			AndFml: evalBool(e.left,b) && evalBool(e.right,b)
			CompareFml: internEvalCompare(e,b)
			default: throw new IllegalStateException("unexpected type of " + e)
		}
	}
	
	
	def static int evalInt(Term e, Binding b){
		switch(e){
			IntConstant : e.value
			ssma.fml.fmlDsl.IntConstant : e.value
			VarRef : b.getVal(e.v)
//			Compound: if(e.typeFor==TermTypeProvider.intType){evalInt(e.t,b)}else{throw new IllegalStateException("wrong eval")}
//			ssma.fml.fmlDsl.Compound: if(e.typeFor==TermTypeProvider.intType){evalInt(e.t,b)}else{throw new IllegalStateException("wrong eval")}
			Compound: evalInt(e.t,b)
			ssma.fml.fmlDsl.Compound: evalInt(e.t,b)
			PlusMinus:  internEvalPlusMinus(e,b)
			MultDiv:  internEvalMultDiv(e,b)
			default: throw new IllegalStateException("unexpected type of " + e)
		}
	}
	
	def private static boolean internEvalCompare(CompareFml e, Binding b){
		val left = evalInt(e.left,b)
		val right = evalInt(e.right,b)
		
		switch e.op {
			case "==" : return left==right
			case "<" : return left<right
			case "<=" : return left<=right
			case ">" : return left>right
			case ">=" : return left>=right
			default: throw new IllegalStateException("Unknown operator " + e.op)
		}
	}
	
	def private static int internEvalPlusMinus(PlusMinus e, Binding b){
		val left = evalInt(e.left,b)
		val right = evalInt(e.right,b)
		
		switch e.op {
			case "+" : return left+right
			case "-" : return left-right
			default: throw new IllegalStateException("Unknown operator " + e.op)
		}
	}

	def private static int internEvalMultDiv(MultDiv e, Binding b){
		val left = evalInt(e.left,b)
		val right = evalInt(e.right,b)
		
		switch e.op {
			case "*" : return left*right
//			case "/" : return left/right  //not yet supported
			default: throw new IllegalStateException("Unknown operator " + e.op)
		}
	}
	
	
}