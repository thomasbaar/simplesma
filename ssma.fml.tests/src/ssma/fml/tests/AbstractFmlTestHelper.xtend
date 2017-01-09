package ssma.fml.tests

import com.google.inject.Inject
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import ssma.fml.fmlDsl.FmlModel
import ssma.fml.fmlDsl.Term
import ssma.fml.typing.TermType
import ssma.fml.typing.TermTypeProvider

import static extension org.junit.Assert.*

abstract class  AbstractFmlTestHelper {

	@Inject extension ParseHelper<FmlModel>
	@Inject extension ValidationTestHelper

	def assertIntType(CharSequence input) {
		input.assertType(TermTypeProvider::intType)
	}

	def assertBoolType(CharSequence input) {
		input.assertType(TermTypeProvider::boolType)
	}

	/**
	 * assertion based on Printer
	 * parameter input: without the ending ';'
	 */
	def assertRepr(CharSequence input, CharSequence expected) {
		(input + ";").parse => [
			assertNoErrors;
			expected.assertEquals(
				terms.map[t].last.rightStringRepr
			)
		]
	}

	/**
	 * assertion based on Printer
	 * parameter input: without the ending ';'
	 */
	def assertReprFromTerm(Term t, CharSequence expected) {
			expected.assertEquals(
				t.rightStringRepr
			)
	}


	/**
	 * To be overridden in subclasses
	 */
	def void assertType(CharSequence input, TermType expectedType) 
	
	/**
	 * To be overridden in subclasses
	 */
	def void assertValue(CharSequence input, CharSequence bindingActions, boolean expected) 


	/**
	 * Returns the string-representation depending of the printer
	 * in the subclasses
	 */
	def String getRightStringRepr(Term t) 
	
	
	
}