package ssma.sminvcb.tests

import ssma.sminv.tests.SminvDslInjectorProvider

class BothLanguagesInjectorProvider extends SminvcbDslInjectorProvider {
	override protected internalCreateInjector() {
		// trigger injector creation of other language
		new SminvDslInjectorProvider().getInjector
		return super.internalCreateInjector()
	}
	
}