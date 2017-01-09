package ssma.sminv.eval

import ssma.sminv.sminvDsl.NegFml
import ssma.sminv.sminvDsl.BoolConstant
import ssma.sminv.sminvDsl.Compound
import ssma.sminv.sminvDsl.IntConstant
import ssma.sminv.sminvDsl.VarRef
import ssma.sminv.typing.TermTypeProviderWithVar
import com.google.inject.Inject
import ssma.fml.typing.TermTypeProvider

class TermEvalProvider {
//	@Inject extension static TermTypeProviderWithVar
	
	
	def static boolean evalBool(ssma.fml.fmlDsl.Term e, Binding b){
		switch(e){
			NegFml : ! evalBool(e.t,b)
			ssma.fml.fmlDsl.NegFml: ! evalBool(e.t,b)
			BoolConstant : if (e.value.equals('true')){true}else{false}
			ssma.fml.fmlDsl.BoolConstant : if (e.value.equals('true')){true}else{false}
//			Compound: if(e.typeFor==TermTypeProvider.boolType){evalBool(e.t,b)}else{throw new IllegalStateException("wrong eval")}
//			ssma.fml.fmlDsl.Compound: if(e.typeFor==TermTypeProvider.boolType){evalBool(e.t,b)}else{throw new IllegalStateException("wrong eval")}
			Compound: evalBool(e.t,b)
			ssma.fml.fmlDsl.Compound: evalBool(e.t,b)
			ssma.fml.fmlDsl.EquivFml: evalBool(e.left,b) == evalBool(e.right,b)
			ssma.fml.fmlDsl.ImpliesFml: ( ! evalBool(e.left,b)) || evalBool(e.right,b)
			ssma.fml.fmlDsl.OrFml: evalBool(e.left,b) || evalBool(e.right,b)
			ssma.fml.fmlDsl.AndFml: evalBool(e.left,b) && evalBool(e.right,b)
			ssma.fml.fmlDsl.CompareFml: internEvalCompare(e,b)
			default: throw new IllegalStateException("unexpected type of " + e)
		}
	}
	
	
	def static int evalInt(ssma.fml.fmlDsl.Term e, Binding b){
		switch(e){
			IntConstant : e.value
			ssma.fml.fmlDsl.IntConstant : e.value
			VarRef : b.getVal(e.v)
//			Compound: if(e.typeFor==TermTypeProvider.intType){evalInt(e.t,b)}else{throw new IllegalStateException("wrong eval")}
//			ssma.fml.fmlDsl.Compound: if(e.typeFor==TermTypeProvider.intType){evalInt(e.t,b)}else{throw new IllegalStateException("wrong eval")}
			Compound: evalInt(e.t,b)
			ssma.fml.fmlDsl.Compound: evalInt(e.t,b)
			ssma.fml.fmlDsl.PlusMinus:  internEvalPlusMinus(e,b)
			ssma.fml.fmlDsl.MultDiv:  internEvalMultDiv(e,b)
			default: throw new IllegalStateException("unexpected type of " + e)
		}
	}
	
	def private static boolean internEvalCompare(ssma.fml.fmlDsl.CompareFml e, Binding b){
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
	
	def private static int internEvalPlusMinus(ssma.fml.fmlDsl.PlusMinus e, Binding b){
		val left = evalInt(e.left,b)
		val right = evalInt(e.right,b)
		
		switch e.op {
			case "+" : return left+right
			case "-" : return left-right
			default: throw new IllegalStateException("Unknown operator " + e.op)
		}
	}

	def private static int internEvalMultDiv(ssma.fml.fmlDsl.MultDiv e, Binding b){
		val left = evalInt(e.left,b)
		val right = evalInt(e.right,b)
		
		switch e.op {
			case "*" : return left*right
//			case "/" : return left/right  //not yet supported
			default: throw new IllegalStateException("Unknown operator " + e.op)
		}
	}
	
	
}