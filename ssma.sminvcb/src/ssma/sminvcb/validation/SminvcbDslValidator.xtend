/*
 * generated by Xtext 2.10.0
 */
package ssma.sminvcb.validation

import com.google.inject.Inject
import org.eclipse.xtext.validation.Check
import ssma.sminvcb.sminvcbDsl.SminvcbDslPackage
import ssma.sminvcb.sminvcbDsl.StatePred

/**
 * This class contains custom validation rules. 
 *
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#validation
 */
class SminvcbDslValidator extends AbstractSminvcbDslValidator {
	@Inject extension SminvcbDslValidatorHelper
	
	@Check(NORMAL)
	def checkPredAreBoolean(StatePred p) {
		checkExpectedBoolean(p.pred, SminvcbDslPackage.Literals.STATE_PRED__PRED)
	}
	
}
