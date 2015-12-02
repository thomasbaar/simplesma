package ssma.fml.tests

import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith
import ssma.fml.FmlDslInjectorProvider

/**
 * Testing the string-representation
 * 
 * Testcases are adapted from Bettini-Book, project org.example.expressions
 */
@RunWith(typeof(XtextRunner))
@InjectWith(typeof(FmlDslInjectorProvider))
class FmlPrinterTest {
	@Inject extension FmlTestHelper

	@Test def void intConstant_withoutParenthesis() { "5".assertRepr("5") }

	@Test
	def void testPlusLeftAssociative() {
		"10 + 5 + 1 + 2".assertRepr("(((10 + 5) + 1) + 2)")
	}

	@Test def void testPlusWithParenthesis() {
		"( 10 + 5 ) + ( 1 + 2 )".assertRepr("((10 + 5) + (1 + 2))")
	}

	@Test
	def void testMinus() {
		"10 + 5 - 1 - 2".assertRepr("(((10 + 5) - 1) - 2)")
	}


	@Test
	def void testPlusMulPrecedence() {
		"10 + 5 * 2 - 5 * 1".assertRepr("((10 + (5 * 2)) - (5 * 1))")
	}

	@Test
	def void testPlusMulPrecedenceWithParenthesis() {
		"(10 + 5) * 2 - 5 * 1".assertRepr("(((10 + 5) * 2) - (5 * 1))")
	}

	@Test def void testComparison_lt() {
		"10 <= 5".assertRepr("(10 <= 5)")
	}

	@Test def void testComparison_eq() {
		"10 == 5".assertRepr("(10 == 5)")
	}
	
	@Test def void andOr() {
		"true || false && 1 < 0".assertRepr("(true || (false && (1 < 0)))")
	}

	@Test def void or_leftAssociative() {
		"true || false || 1 < 0".assertRepr("((true || false) || (1 < 0))")
	}

	@Test def void and_leftAssociative() {
		"true && false && 1 < 0".assertRepr("((true && false) && (1 < 0))")
	}

	@Test def void equiv_ImpliesPrecedence() {
		"true -> false <-> true".assertRepr("((true -> false) <-> true)")
	}

	@Test def void testNot() {
		"!true||false".assertRepr("((!true) || false)")
	}

	@Test def void testNotWithParentheses() {
		"!(true||false)".assertRepr("(!(true || false))")
	}

	@Test def void testPrecedences() {
		"!true||false&&1>(1*3+5*2)".assertRepr("((!true) || (false && (1 > ((1 * 3) + (5 * 2)))))")
	}

}