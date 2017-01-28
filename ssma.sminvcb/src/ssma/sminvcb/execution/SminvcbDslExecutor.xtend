package ssma.sminvcb.execution

import org.eclipse.emf.ecore.resource.Resource
import ssma.sminvcb.sminvcbDsl.SminvcbModel
import com.google.inject.Inject
import ssma.sminvcb.printing.SminvcbDslPrinter

class SminvcbDslExecutor {
	
	@Inject
	var SminvcbDslPrinter  printer	
	
	
	//TODO: try to understand why only one resource (sminvcb) is sufficient here
	//     (and I can navigate even to the referred sminv-model)
	def process(Resource resource){
		val model = resource.allContents
				.filter(typeof(SminvcbModel)).head
				
		println("MYLOG : in executor.process()")		
				
		println("MYLOG cb-model is : " + printer.stringRepr(model))
	}
	
}