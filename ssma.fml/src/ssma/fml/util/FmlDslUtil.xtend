package ssma.fml.util

import com.google.inject.Inject
import org.eclipse.xtext.xbase.lib.util.ReflectExtensions
import ssma.fml.fmlDsl.FmlDslFactory
import ssma.fml.fmlDsl.Term
import ssma.fml.typing.TermTypeProvider

class FmlDslUtil {

	@Inject extension TermTypeProvider
	@Inject extension ReflectExtensions

	/**
	 * Will create a new and-formula with the arguments as children
	 * NOTE: The arguments should have no parents, since the newly
	 * created and-formula will become their parent.
	 */
	def and(Term leftT, Term rightT) {
		composeBinaryTerm(Op.AND, leftT, rightT)
	}

	def or(Term leftT, Term rightT) {
		composeBinaryTerm(Op.OR, leftT, rightT)
	}

	def implies(Term leftT, Term rightT) {
		composeBinaryTerm(Op.IMPLIES, leftT, rightT)
	}

	def equiv(Term leftT, Term rightT) {
		composeBinaryTerm(Op.EQUIV, leftT, rightT)
	}
	
	def neg(Term subT){
		checkSubterm(subT)
		val term = FmlDslFactory::eINSTANCE.createNegFml
		val compoundSubT = FmlDslFactory::eINSTANCE.createCompound
		compoundSubT.invoke("setT", subT)
		term.invoke("setT", compoundSubT) // NegFml expects Atomic, 
		                        // so we have to wrap subT with parenthesis
		term
	}

	private def Term composeBinaryTerm(Op op, Term leftT, Term rightT) {
		checkSubterm(leftT)
		checkSubterm(rightT)

		val term = switch op {
			case AND: FmlDslFactory::eINSTANCE.createAndFml
			case OR: FmlDslFactory::eINSTANCE.createOrFml
			case IMPLIES: FmlDslFactory::eINSTANCE.createImpliesFml
			case EQUIV: FmlDslFactory::eINSTANCE.createEquivFml
		}

		// TODO: the following implementation results in type error; is there any technique to make it without reflection?
		//
//		term => [
//			left = leftT
//			right = rightT
//		]
		term.invoke("setLeft", leftT)
		term.invoke("setRight", rightT)

		term
	}

	private def checkSubterm(Term t) {
		if (! t.typeFor.isBoolean)
			throw new IllegalArgumentException("")
		if (t.eContainer != null)
			throw new IllegalArgumentException("")
	}

	enum Op {
		AND,
		OR,
		IMPLIES,
		EQUIV
	}
}