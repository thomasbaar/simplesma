package ssma.fml.validation

import ssma.fml.fmlDsl.Term
import org.eclipse.emf.ecore.EReference
import ssma.fml.typing.TermTypeProvider
import ssma.fml.typing.TermType
import com.google.inject.Inject

/**
 * provides useful methods to be used in sub-classes
 */
class FmlDslValidatorHelper {

	@Inject extension TermTypeProvider
	@Inject  FmlDslValidator v

	// later we change the validator, so we enclose
	// v by a getter
	def protected FmlDslValidator  getV(){
		v
	}

	def checkExpectedBoolean(Term exp, EReference reference) {
		checkExpectedType(exp, TermTypeProvider::boolType, reference)
	}

	def checkExpectedInt(Term exp, EReference reference) {
		checkExpectedType(exp, TermTypeProvider::intType, reference)
	}

	def protected checkExpectedType(Term exp, TermType expectedType, EReference reference) {
		val actualType = getTypeAndCheckNotNull(exp, reference)
		if (actualType != expectedType)
			getV.perror("expected " + expectedType + " type, but was " + actualType, reference, FmlDslValidator::WRONG_TYPE)
	}

	def protected TermType getTypeAndCheckNotNull(Term exp, EReference reference) {
		var type = exp?.typeFor
		if (type == null)
			getV.perror("null type", reference, FmlDslValidator::WRONG_TYPE)
		return type;
	}

}