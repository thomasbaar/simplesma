package ssma.fml.tests

import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.junit.Test
import org.junit.runner.RunWith
import ssma.fml.tests.FmlDslInjectorProvider
import ssma.fml.fmlDsl.FmlModel
import ssma.fml.util.FmlDslUtil


import static extension org.eclipse.emf.ecore.util.EcoreUtil.*

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(FmlDslInjectorProvider))
class FmlUtilTest {
	@Inject extension FmlTestHelper
	@Inject extension ParseHelper<FmlModel>
	@Inject extension FmlDslUtil

	@Test
	def void testAllOps_plain() {
		val model = "10 < 5".parse
		val t = model.terms.head.t
		t.assertReprFromTerm("(10 < 5)")
		
		t.copy.and(t.copy).assertReprFromTerm("((10 < 5) && (10 < 5))")
		t.copy.or(t.copy).assertReprFromTerm("((10 < 5) || (10 < 5))")
		t.copy.implies(t.copy).assertReprFromTerm("((10 < 5) -> (10 < 5))")
		t.copy.equiv(t.copy).assertReprFromTerm("((10 < 5) <-> (10 < 5))")
		t.copy.neg.assertReprFromTerm("(!(10 < 5))")
		neg(t.copy).assertReprFromTerm("(!(10 < 5))")
	}
 
	@Test
	def void testAnd_Nested() {
		val model = "10 < 5 || 5 + 7 < 23".parse
		val t = model.terms.head.t
		t.assertReprFromTerm("((10 < 5) || ((5 + 7) < 23))")
		t.copy.and(t.copy).assertReprFromTerm("(((10 < 5) || ((5 + 7) < 23)) && ((10 < 5) || ((5 + 7) < 23)))")
	}


}