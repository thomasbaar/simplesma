/*
 * generated by Xtext 2.10.0
 */
package ssma.sminvcb


/**
 * Initialization support for running Xtext languages without Equinox extension registry.
 */
class SminvcbDslStandaloneSetup extends SminvcbDslStandaloneSetupGenerated {

	def static void doSetup() {
		new SminvcbDslStandaloneSetup().createInjectorAndDoEMFRegistration()
	}
}