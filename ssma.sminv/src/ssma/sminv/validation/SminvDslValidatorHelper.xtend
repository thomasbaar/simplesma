package ssma.sminv.validation

import com.google.inject.Inject
import org.eclipse.emf.ecore.EReference

import ssma.fml.validation.FmlDslValidatorHelper
import ssma.fml.typing.TermType

import ssma.sminv.typing.TermTypeProviderWithVar

class SminvDslValidatorHelper extends FmlDslValidatorHelper {

//	@Inject extension TermTypeProviderWithVar
	@Inject SminvDslValidator v


	override protected SminvDslValidator  getV(){
		v
	}
//
//	override checkExpectedBoolean(ssma.fml.fmlDsl.Term exp, EReference reference) {
//		super.checkExpectedBoolean(exp, reference)
//	}


//	override protected checkExpectedType(ssma.fml.fmlDsl.Term exp, TermType expectedType, EReference reference) {
//		val actualType = getTypeAndCheckNotNull(exp, reference)
//		if (actualType != expectedType){
//			try{
//				throw new IllegalStateException()
//			}catch(Exception e){
//				e.printStackTrace
//			}
//			getV.perror("expected " + expectedType + " type, but was " + actualType, reference,
//				SminvDslValidator::WRONG_TYPE)
//				}
//	}
//
//	override protected TermType getTypeAndCheckNotNull(ssma.fml.fmlDsl.Term exp, EReference reference) {
//		if (exp==null) throw new IllegalArgumentException("arg not null")
//		var type = exp?.typeFor
//		if (type == null)
//			getV.perror("null type", reference, SminvDslValidator::WRONG_TYPE)
//		return type;
//	}

}