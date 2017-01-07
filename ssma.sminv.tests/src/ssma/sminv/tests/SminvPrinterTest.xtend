package ssma.sminv.tests

import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith
import ssma.sminv.tests.SminvDslInjectorProvider

/**
 * Testing the string-representation
 * 
 * Testcases are adapted from Bettini-Book, project org.example.expressions
 */

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(SminvDslInjectorProvider))
class SminvPrinterTest {
	@Inject extension SminvTestHelper

//	@Test def void intConstant() { "5;".assertIntType }

	@Test
	def void testPlus() {
		'''5 < 10 + 5 + 1 + 2'''.assertGuardRepr("(5 < (((10 + 5) + 1) + 2))")
	}

	@Test def void testPlusWithParenthesis() {
		"5 < ( 10 + 5 ) + ( 1 + 2 )".assertGuardRepr("(5 < ((10 + 5) + (1 + 2)))")
	}

	@Test
	def void testMinus() {
		"5 < 10 + 5 - 1 - 2".assertGuardRepr("(5 < (((10 + 5) - 1) - 2))")
	}


	@Test
	def void testPlusMulPrecedence() {
		"5 < 10 + 5 * 2 - 5 * 1".assertGuardRepr("(5 < ((10 + (5 * 2)) - (5 * 1)))")
	}

	@Test
	def void testPlusMulPrecedenceWithParenthesis() {
		"5 < (10 + 5) * 2 - 5 * 1".assertGuardRepr("(5 < (((10 + 5) * 2) - (5 * 1)))")
	}

	@Test def void testComparison() {
		"10 >= 5".assertGuardRepr("(10 >= 5)")
	}


	@Test def void testAndOr() {
		"true || false && 1 < 0".assertGuardRepr("(true || (false && (1 < 0)))")
	}

	@Test def void testNot() {
		"!true||true".assertGuardRepr("((!true) || true)")
	}

	@Test def void testNotWithParentheses() {
		"!(true&&false)".assertGuardRepr("(!(true && false))")
	}

	@Test def void testPrecedences() {
		"!true||true&&1<(1*3+5*2)".assertGuardRepr("((!true) || (true && (1 < ((1 * 3) + (5 * 2)))))")
	}
	
	@Test def void testVarRef() {
		"! (v1 < 5)".assertGuardRepr("(!(v1 < 5))")
	}
	

}