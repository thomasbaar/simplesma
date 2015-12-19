package ssma.sminv.tests

import com.google.inject.Inject
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import ssma.fml.fmlDsl.Term
import ssma.fml.tests.AbstractFmlTestHelper
import ssma.fml.typing.TermType
import ssma.fml.validation.FmlDslValidator
import ssma.sminv.printing.SminvDslPrinter
import ssma.sminv.sminvDsl.SminvDslPackage
import ssma.sminv.sminvDsl.SminvModel
import ssma.sminv.typing.TermTypeProviderWithVar
import ssma.sminv.util.SminvDslUtil

import static extension org.junit.Assert.*

class SminvTestHelper extends AbstractFmlTestHelper {

	@Inject extension ParseHelper<SminvModel>
	@Inject extension ValidationTestHelper
	@Inject extension TermTypeProviderWithVar
	@Inject extension SminvDslPrinter
	@Inject extension SminvDslUtil

	// note that here the local ParseHelper comes into effect
	override assertType(CharSequence input, TermType expectedType) {
		val model = input.guardToSminvInput.parse
		model.assertNoErrors // check syntactic correctness first
		expectedType.assertSame(model.transitions.get(1).g.typeFor) // here we extract guard -> always boolean
	}

	def guardToSminvInput(CharSequence input) {
		val prefix = '''vars v1 v2
	               states start a b
	               events ev1 
	               transitions  start => a; a => b ev1 ['''
		prefix + input + '''];'''
	}

	def invToSminvInput(CharSequence input) {
		val prefix = '''vars v1 v2
	               states start a b
	               events ev1 
	               transitions  start => a;
	               invariants b : '''
		prefix + input + ''';'''
	}

	/**
	 * test the string representation when input is given as a guard
	 */
	def assertGuardRepr(CharSequence input, CharSequence expected) {
		input.guardToSminvInput.parse => [
			assertNoErrors;
			expected.assertEquals(
				transitions.get(1).g.stringRepr
			)
		]
	}

	def assertGuardValidationError(CharSequence input) {
		input.parse.assertError(SminvDslPackage.Literals.TRANSITION, FmlDslValidator.WRONG_TYPE)
	}

	def assertInvValidationError(CharSequence input) {
		input.parse.assertError(SminvDslPackage.Literals.INV, FmlDslValidator.WRONG_TYPE)
	}

	override getRightStringRepr(Term t) {
		t.stringRepr
	}

}