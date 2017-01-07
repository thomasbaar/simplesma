package ssma.fml.tests

/**
 * Tests of the validator
 */

import org.eclipse.xtext.junit4.XtextRunner
import org.junit.runner.RunWith
import org.eclipse.xtext.junit4.InjectWith
import ssma.fml.tests.FmlDslInjectorProvider
import com.google.inject.Inject
import org.eclipse.xtext.junit4.util.ParseHelper
import ssma.fml.fmlDsl.FmlModel
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.junit.Test
import ssma.fml.validation.FmlDslValidator
import ssma.fml.fmlDsl.FmlDslPackage

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(FmlDslInjectorProvider))
class FmlValidatorTest {
		@Inject extension ParseHelper<FmlModel>
	@Inject extension ValidationTestHelper
	
	@Test def void equivLeft(){'''5 <-> true'''.assertValidationTypeError}
	
	@Test def void equivRight(){'''false <-> 5'''.assertValidationTypeError}
	
	@Test def void impliesLeft(){'''5 -> true'''.assertValidationTypeError}
	
	@Test def void impliesRight(){'''false -> 5'''.assertValidationTypeError}
	
	@Test def void orLeft(){'''5 || true'''.assertValidationTypeError}
	
	@Test def void orRight(){'''false || 5'''.assertValidationTypeError}
	
	@Test def void andLeft(){'''5 && true'''.assertValidationTypeError}
	
	@Test def void andRight(){'''false && 5'''.assertValidationTypeError}
	
	@Test def void compLeft(){'''true == 5'''.assertValidationTypeError}
	
	@Test def void compRight(){'''5 == false'''.assertValidationTypeError}
	
	@Test def void plusMinusLeft(){'''true - 5'''.assertValidationTypeError}
	
	@Test def void plusMinusRight(){'''5 - true'''.assertValidationTypeError}
	
	@Test def void multDivLeft(){'''true * 5'''.assertValidationTypeError}
	
	@Test def void multDivRight(){'''5 * true'''.assertValidationTypeError}
	
	@Test def void neg(){'''! (5)'''.assertValidationTypeError}
	
	def assertValidationTypeError(CharSequence input){
		input.parse.assertError(FmlDslPackage$Literals::TERM, FmlDslValidator.WRONG_TYPE)
	}
}