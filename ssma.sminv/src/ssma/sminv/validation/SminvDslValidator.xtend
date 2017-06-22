/*
 * generated by Xtext
 */
package ssma.sminv.validation

import java.util.ArrayList
import org.eclipse.xtext.validation.Check
import com.google.inject.Inject
import de.htwberlin.selab.princessintegration.PrincessFacade
import ssma.sminv.pogenerator.SminvDslPOGenerator
import ssma.sminv.printing.SminvDslPrincessPrinter
import ssma.sminv.sminvDsl.Inv
import ssma.sminv.sminvDsl.SminvDslPackage
import ssma.sminv.sminvDsl.SminvModel
import ssma.sminv.sminvDsl.Transition
import ssma.sminv.util.SminvDslUtil

import static extension org.eclipse.xtext.EcoreUtil2.*

/**
 * This class contains custom validation rules. 
 *
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#validation
 */
class SminvDslValidator extends AbstractSminvDslValidator {

	@Inject extension SminvDslValidatorHelper
	@Inject extension SminvDslUtil

	@Inject extension SminvDslPOGenerator
	@Inject extension SminvDslPrincessPrinter

	@Inject PrincessFacade princessProver

	public static val STARTSTATE_IS_NO_TRANSITIONTARGET = "startstate.is.no.transitiontarget"
	public static val STARTSTATE_HAS_ONE_OUTTRANSITION = "startstate.has.one.outtransition"
	public static val STARTSTATE_HAS_NO_INVARIANT = "startstate.has.no.invariant"
	public static val OUTTRANSITION_NO_EVENT = "outtransition.no.event"
	public static val OUTTRANSITION_NO_GUARD = "outtransition.no.guard"
	public static val TRANSITION_HAS_EVENT = "transition.has.event"
	public static val TRANSITION_UPDATES_HAS_UNIQUE_LHSS = "transition.updates.has.unique.lhss"
	public static val TRANSITION_MUST_PRESERVE_INVARIANTS = "transition.must.preserve.invariants"
	public static val TRANSITION_MUST_BE_ALIVE = "transition.must.be.alive"
	public static val INCOMING_TRANSITION_MUST_PRESERVE_INVARIANT = "incoming.transition.must.preserve.invariant"
	public static val OUTGOING_TRANSITIONS_MUST_NOT_BE_NONDETERMINISTIC = "outgoing.transitions.must.not.be.nondeterministic"

	@Check(NORMAL)
	def checkGuardsAreBoolean(Transition trans) {
		if (trans.g != null)
			checkExpectedBoolean(trans.g, SminvDslPackage.Literals.TRANSITION__G)
	}

	@Check(NORMAL)
	def checkInvAreBoolean(Inv inv) {
		if (inv.inv != null)
			checkExpectedBoolean(inv.inv, SminvDslPackage.Literals.INV__INV)
	}

	@Check
	def checkTransitionsTargetStateIsNeverStartState(Transition t) {
		if (t.post.isStartState)
			error("target of transition cannot be a start state", SminvDslPackage.Literals.TRANSITION__POST,
				STARTSTATE_IS_NO_TRANSITIONTARGET)
	}

	@Check(NORMAL)
	def checkStartStateHasExactlyOneOutgoingTransition(ssma.sminv.sminvDsl.State s) {
		if (s.isStartState) {
			val outgoingTransitions = s.getContainerOfType(typeof(SminvModel)).td.trans.filter[pre == s]
			if (outgoingTransitions.size != 1)
				error("start state must have exactly one outgoing transition", SminvDslPackage.Literals.STATE__NAME,
					STARTSTATE_HAS_ONE_OUTTRANSITION)
		}
	}
	
	@Check
	def checkAllTransitionsExceptFromStartStateHaveEvent(Transition t) {
		if (t.ev==null && !t.pre.isStartState) {
			error("this transition must have an event attached",
					SminvDslPackage.Literals.TRANSITION__EV, TRANSITION_HAS_EVENT)
		}
	}

	

	@Check
	def checkOutgoingTransitionForStartStateHasNoEventNoGuard(Transition t) {
		if (t.pre.isStartState) {
			if (t.ev != null)
				error("outgoing transition from start state must have neither event nor guard",
					SminvDslPackage.Literals.TRANSITION__EV, OUTTRANSITION_NO_EVENT)
			if (t.g != null)
				error("outgoing transition from start state must have neither event nor guard",
					SminvDslPackage.Literals.TRANSITION__G, OUTTRANSITION_NO_GUARD)
		}
	}

	@Check
	def checkStartStateHasNoInvariant(ssma.sminv.sminvDsl.State s) {
		if (s.isStartState) {
			if (s.invariants.size != 0)
				error(
					"start state must not have any invariant (note that invariant 'true' is always implicitly attached to a state)",
					SminvDslPackage.Literals.STATE__NAME, STARTSTATE_HAS_NO_INVARIANT)
		}
	}

	@Check
	def checkTransitionsUpdatesHasOnlyOneClausePerVariable(Transition t) {
		val updates = t.act
		val lhvars = updates.map[variable].toSet

		if (updates.size != lhvars.size) {
			error("the updates of a transition must have only one assignment per variable",
				SminvDslPackage.Literals.TRANSITION__ACT, TRANSITION_UPDATES_HAS_UNIQUE_LHSS)
		}
	}

	//
	// prove proof obligations using Princess
	//
	// temporarily commented out since next one is equivalent
//	@Check(NORMAL)
//	def checkTransitionPOWithPrincess(published.Sminv.SminvDsl.Transition t) {
//		val po = t.PO_InvPreservation.princessRepr
//		var result = princessProver.prove(po, "InvPreservation-PO for transition " + t.toString())
//
//		if (!result.isProven) {
//			error(
//				"the transition does not preserve the invariants. The post-state invariant is broken, if the transition fires in the following pre-state: " +
//					result.counterexample, SminvDslPackage.Literals.TRANSITION__POST,
//				TRANSITION_MUST_PRESERVE_INVARIANTS)
//		}
//	}

//
//	// here we use PRINCESS
//
//

// temporarily commented out for accelerating mutation tests

//	@Check(NORMAL) // TODO: substitute with EXPENSIVE here
//	def check_InvPreservation_ForInvariant(Inv inv) {
//		val incomingTrans = inv.state.incomingTransitions
//
//		for (Transition t : incomingTrans) {
//			val po = t.getPO_InvPreservation_ForPostInvariant(inv).princessRepr
//			var result = princessProver.prove(po,
//				"InvPreservation-PO for transition " + t.toString() + " and inv " + inv.toString)
//
//			if (!result.isProven) {
//				error(
//					"NOT INVARIANT-PRESERVING: the transition " + t.printName +
//						" does not preserve this invariant, if the transition fires in the following pre-state: " +
//						result.counterexample, SminvDslPackage.Literals.INV__INV,
//					INCOMING_TRANSITION_MUST_PRESERVE_INVARIANT)
//				}
//			}
//		}
//
//		// here we use PRINCESS
//		@Check(NORMAL)
//		def check_OutgoingTransitionOnNondetermismNew(ssma.sminv.sminvDsl.State s) {
//			val outgoingsGroupedByEvent = s.outgoingTransitions.groupBy[t|if(t.ev == null) "" else t.ev.name]
//
//			for (String eventName : outgoingsGroupedByEvent.keySet()) {
//				val group = outgoingsGroupedByEvent.get(eventName)
//
//				val Iterable<Pair<Transition, Transition>> pairs = getPairwiseCombinations(group)
//				for (Pair<Transition, Transition> p : pairs) {
//					val t1 = p.key
//					val t2 = p.value
//					val poTerm = t1.getPO_NonDeterminism(t2)
//					val po = poTerm.princessRepr
//					var result = princessProver.prove(po, "NonDeterminism-PO")
//					if (!result.isProven) {
//						error(
//							"NON-DETERMINISM: the outgoing transitions " + t1.printName + " and " + t2.printName +
//								"are in conflict and cold both fire in the following pre-state: " +
//								result.counterexample,
//								SminvDslPackage.Literals.STATE__NAME,
//								OUTGOING_TRANSITIONS_MUST_NOT_BE_NONDETERMINISTIC
//							)
//						}
//					}
//				}
//			}
//
//			private def Iterable<Pair<Transition, Transition>> getPairwiseCombinations(Iterable<Transition> group) {
//				if (group.size < 2)
//					return new ArrayList<Pair<Transition, Transition>>()
//				val t1 = group.head
//				group.tail.map[t2|t1 -> t2] + getPairwiseCombinations(group.tail)
//			}
//
//			// here we use PRINCESS
//			@Check(NORMAL) // TODO: substitute with EXPENSIVE here
//			def check_AliveTransition(Transition t) {
//				val po = t.PO_AliveTransition.princessRepr(false)
//				var result = princessProver.prove(po, "AliveTransition-PO for transition " + t.toString())
//
//				if (!result.isProven) {
//					error(
//						"DEAD TRANSITION: the transition " + t.printName +
//							" is dead; its guard together with the invariant(s) of the pre-state is not satisfiable",
//						SminvDslPackage.Literals.TRANSITION__G, TRANSITION_MUST_BE_ALIVE)
//				}
//			}

}
