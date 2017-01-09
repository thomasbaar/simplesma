package ssma.sminv.util

import com.google.inject.Inject
import java.util.ArrayList
import ssma.fml.util.FmlDslUtil
import ssma.sminv.printing.SminvDslPrinter
import ssma.sminv.sminvDsl.Inv
import ssma.sminv.sminvDsl.SminvModel
import ssma.sminv.sminvDsl.State
import ssma.sminv.sminvDsl.StateDecl
import ssma.sminv.sminvDsl.Transition
import ssma.sminv.typing.TermTypeProviderWithVar

import static extension org.eclipse.xtext.EcoreUtil2.*


/**
 * TODO: this class is basically a copy of the original Util-Class
 * because a some point the injected util-object did not work
 * (NPE) but syntactically all was ok (see ExecutionState)
 */

//class SminvDslUtil_Static extends FmlDslUtil {
class SminvDslUtil_Static {

//	@Inject extension TermTypeProviderWithVar
	@Inject extension static  SminvDslPrinter

//	protected override checkSubterm(ssma.fml.fmlDsl.Term t) {
//		if (! t.typeFor.isBoolean)
//			// throwing an exception can abort the validation process and 
//			// shadow other error messages
////			throw new IllegalArgumentException("")
//			System.out.println("Warning: SminvDslUtil.checkSubterm received non-boolean argument")
//		if (t.eContainer != null)
////			throw new IllegalArgumentException("")
//			System.out.println("Warning: SminvDslUtil.checkSubterm received argument with null-container")
//	}

	//
	// navigation shortcuts
	//
	def static getInvariants(SminvModel model) {
		// id is the only feature of SminvModel that can be null
		if (model.id == null)
			new ArrayList<Inv>()
		else {
			model.id.invs
		}
	}

	def static Iterable<Transition> getTransitions(SminvModel model) {
		model.td.trans
	}

	def static getStates(SminvModel model) {
		model.sd.states
	}

	def static getEvents(SminvModel model) {
		model.ed.events
	}
	
	def static getVars(SminvModel model) {
		model.vd.vars
	}
	
	def static getStartState(SminvModel model) {
		model.states.head
	}

	def static Iterable<Inv> getInvariants(State s) {
		s.root.invariants.filter[state == s]
	}

	def static getRoot(State s) {
		s.getContainerOfType(typeof(SminvModel))
	}

	//
	// derived attributes
	//
	def static boolean isStartState(State s) {
		(s.eContainer as StateDecl).states.head == s
	}

	def static String getPrintName(Transition t) {
		'''«t.pre.name» => «t.post.name» ''' + '''«IF t.ev != null»«t.ev.name» «ENDIF»''' +
			'''«IF t.g != null»[«t.g.stringRepr»]«ENDIF»''' +
			'''«IF t.act.size != 0» / «FOR up : t.act»«up.variable.name» «up.op» «up.value.stringRepr» «ENDFOR»«ENDIF»'''
	}

	def static getIncomingTransitions(State s) {
		s.root.transitions.filter[post == s]
	}

	def static getOutgoingTransitions(State s) {
		s.root.transitions.filter[pre == s]
	}
}