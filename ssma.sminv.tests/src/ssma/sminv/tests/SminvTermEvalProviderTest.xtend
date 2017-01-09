package ssma.sminv.tests

import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith
import ssma.sminv.tests.SminvDslInjectorProvider


@RunWith(typeof(XtextRunner))
@InjectWith(typeof(SminvDslInjectorProvider))
class SminvTermEvalProviderTest {

	@Inject extension SminvTestHelper


	//TODO: we can only test for BoolType so far; just find a way also to test on int-type


	@Test def void boolConstant1() { "true".assertValue("", true) }
	@Test def void boolConstant2() { " ! false".assertValue("", true) }


	@Test def void intOps() { 
		"3 + 5 == 8".assertValue("", true) 
		"3 + 5 - 2 == 6".assertValue("", true) 
		"3 - 5 == 0 - 2".assertValue("", true) 
		"3 * 5 == 15".assertValue("", true) 
		"    3 <  5".assertValue("", true) 
		"    3 <=  5".assertValue("", true) 
		"    5 > 3".assertValue("", true) 
		"    5 >=  5".assertValue("", true) 
	}


	@Test def void boolOps() { 
		"!(true && false)".assertValue("", true) 
		"(true || false)".assertValue("", true) 
		"!(true -> false)".assertValue("", true) 
		"(false -> true)".assertValue("", true) 
		"!(true <-> false)".assertValue("", true) 
	}

	@Test def void evalVarOps() { 
		"v1 + v2 == 8".assertValue("v1=3 v2+=5", true) 
	}

}

