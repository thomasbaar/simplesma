package ssma.sminvcb.ui.handler

import com.google.inject.Inject
import org.eclipse.core.commands.AbstractHandler
import org.eclipse.core.commands.ExecutionEvent
import org.eclipse.core.commands.ExecutionException
import org.eclipse.core.commands.IHandler
import org.eclipse.core.resources.IFile
import org.eclipse.core.resources.IProject
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.jface.viewers.ISelection
import org.eclipse.jface.viewers.IStructuredSelection
import org.eclipse.ui.handlers.HandlerUtil
import org.eclipse.xtext.ui.resource.IResourceSetProvider
import ssma.sminvcb.execution.SminvcbDslExecutor

class SimulationHandler extends AbstractHandler implements IHandler {

	@Inject
	var IResourceSetProvider resourceSetProvider;

	@Inject
	var SminvcbDslExecutor executor
	
	override Object execute(ExecutionEvent event) throws ExecutionException {

		println("MYLOG: hello from SimulationHandler")
		processSelection(event)
	}

	override boolean isEnabled() {
		return true;
	}

	private def processSelection(ExecutionEvent event) {
		val ISelection selection = HandlerUtil.getCurrentSelection(event);
		if (selection instanceof IStructuredSelection) {
			println("MYLOG: in IStructuredSelection")
			val IStructuredSelection structuredSelection = selection as IStructuredSelection;
			val Object firstElement = structuredSelection.getFirstElement();
			if (firstElement instanceof IFile) {
				val IFile file = firstElement as IFile;
				val IProject project = file.getProject();

				val URI uri = URI.createPlatformResourceURI(file.getFullPath().toString(), true);
				val ResourceSet rs = resourceSetProvider.get(project);
				val Resource r = rs.getResource(uri, true);

				println("MYLOG: current resource has name " + r.URI)

				executor.process(r)
			}
		}
	}

}
