package ssma.sminv.tests

import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith
import ssma.sminv.SminvDslInjectorProvider

// we inherit from the superclass in order to the 
// helper methods (e.g. assertIntType)
@RunWith(typeof(XtextRunner))
@InjectWith(typeof(SminvDslInjectorProvider))
class SminvTermTypeProviderWithVarTest {

	@Inject extension SminvTestHelper


	//TODO: we can only test for BoolType so far; just find a way also to test on int-type


	@Test def void boolConstant() { "true".assertBoolType }

	@Test def void compoundBool() {"(true )".assertBoolType}

//	@Test def void compoundInt() {"(45 ) ;".assertIntType}
//	
	@Test def void negFml() {"!( 4 > 6 )".assertBoolType}

	@Test def void varRef() {"v1 < 6".assertBoolType}

	}


