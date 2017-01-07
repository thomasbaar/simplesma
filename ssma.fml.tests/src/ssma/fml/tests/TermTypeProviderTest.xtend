package ssma.fml.tests

import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith
import ssma.fml.tests.FmlDslInjectorProvider
import ssma.fml.typing.TermTypeProvider

import static extension org.junit.Assert.assertTrue

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(FmlDslInjectorProvider))
class TermTypeProviderTest {

	@Inject extension TermTypeProvider

	@Inject extension FmlTestHelper

	@Test def void intConstant() { "5;".assertIntType }

	@Test def void boolConstant() { "true;".assertBoolType }

	@Test def void compoundBool() { "(false ) ;".assertBoolType }

	@Test def void compoundInt() { "(45 ) ;".assertIntType }

	@Test def void negFml() { "!( true ) ;".assertBoolType }

	@Test def void multdiv() { "5 * 9;".assertIntType }

	@Test def void plusminus() { "5 + 9;".assertIntType }

	@Test def void cmpfml() { "4 == 5;".assertBoolType }

	@Test def void andfml() { "true && 4 < 5;".assertBoolType }

	@Test def void orfml() { "true || 4 < 5;".assertBoolType }

	@Test def void impliesfml() { "true -> 4 < 5;".assertBoolType }

	@Test def void equivfml() { "true <-> 4 < 5;".assertBoolType }

	@Test def void testIsInt() {
		(TermTypeProvider::intType).isInt.assertTrue
	}

	@Test def void testIsBool() {
		(TermTypeProvider::boolType).isBoolean.assertTrue
	}

}