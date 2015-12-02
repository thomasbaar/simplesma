package ssma.fml.tests

/**
 * the parser tests for the grammar.
 * 
 * Note that there are implicitly additional parser tests
 * in sibling class TermTypeProviderTest
 */

import org.eclipse.xtext.junit4.XtextRunner
import org.junit.runner.RunWith
import org.eclipse.xtext.junit4.InjectWith
import ssma.fml.FmlDslInjectorProvider
import com.google.inject.Inject
import org.eclipse.xtext.junit4.util.ParseHelper
import ssma.fml.fmlDsl.FmlModel
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.junit.Test
import ssma.fml.fmlDsl.FmlDslPackage
import org.eclipse.xtext.diagnostics.Diagnostic

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(FmlDslInjectorProvider))
class FmlParserTest {
	@Inject extension ParseHelper<FmlModel>
	@Inject extension ValidationTestHelper

	//
	// Successful Parsing
	//
	@Test def void intconstant(){'''5;'''.parse.assertNoErrors}
	@Test def void plus(){'''5 + 7;'''.parse.assertNoErrors}
	@Test def void implication(){'''5 + 7 - 2 < 34 -> 10 >= 23;'''.parse.assertNoErrors}
	@Test def void or(){'''1 < 4 && 3 < 7 || 9 > 0;'''.parse.assertNoErrors}
	@Test def void nestedNegation(){'''!! true;'''.parse.assertNoErrors}

	@Test def void nestedEquivWithParenthesis(){'''(true <-> false) <-> true;'''.parse.assertNoErrors}
	@Test def void nestedImpliesWithParenthesis(){'''true -> (false -> true);'''.parse.assertNoErrors}
	@Test def void nestedEquivImplies(){'''true -> false <-> true;'''.parse.assertNoErrors}


	//
	// Unsuccessful Parsing
	//

	@Test def void unknownOperator1(){'''!-! 5;'''.assertIncorrectTerm}
	@Test def void unknownOperator2(){'''true >> 5;'''.assertIncorrectTerm}
	@Test def void unknownOperator3(){'''true <== false;'''.assertIncorrectTerm}
	
	@Test def void nestedEquivMissingParenthesis(){'''true <-> false <-> true;'''.assertIncorrectTermWithSeperator}
	@Test def void nestedImpiesMissingParenthesis(){'''true -> false -> true;'''.assertIncorrectTermWithSeperator}
	
	
	def assertIncorrectTerm(CharSequence inp) {
		inp.parse.assertError(FmlDslPackage$Literals::TERM, Diagnostic.SYNTAX_DIAGNOSTIC)
	}

	def assertIncorrectTermWithSeperator(CharSequence inp) {
		inp.parse.assertError(FmlDslPackage$Literals::TERM_WITH_SEPARATOR, Diagnostic.SYNTAX_DIAGNOSTIC)
	}
	
	
}