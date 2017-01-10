package ssma.sminvcb.validation

import com.google.inject.Inject

import ssma.sminv.validation.SminvDslValidatorHelper
import ssma.sminv.validation.SminvDslValidator

class SminvcbDslValidatorHelper extends SminvDslValidatorHelper{
	
		@Inject SminvcbDslValidator v
	
	
	override protected SminvDslValidator  getV(){
		v
	}
	
}