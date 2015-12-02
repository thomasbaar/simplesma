package de.htwberlin.selab.princessintegration;

import ap.CmdlMain;
import ap.DialogUtil$;
import ap.Prover.CounterModel;
import ap.Prover.Model;
import ap.Prover.NoCounterModel$;
import ap.Prover.Proof;
import ap.Prover.ProofWithModel;
import ap.Prover.Result;
import ap.parameters.GlobalSettings;
import ap.parameters.Param;
import ap.parser.PrincessLineariser$;

/**
 * Provides an easy to use wrapper for the theorem prover PRINCESS (see
 * http://www.philipp.ruemmer.org/princess.shtml )
 * 
 * @author BAAR
 *
 */

public class PrincessFacade {

	public synchronized PrincessFacadeResult prove(final String po,
			final String problemName) throws PrincessFacadeException {

		PrincessFacadeResult result = new PrincessFacadeResult();
		final scala.Tuple2<scala.Option<Result>, String> resPair =
                    DialogUtil$.MODULE$.captureOutput
                    (new scala.runtime.AbstractFunction0<scala.Option<Result>>() {
                        public scala.Option<Result> apply() {
                            return proveCore(po, problemName);
                        }
                    });
                final scala.Option<Result> rawResult = resPair._1();
                final String output = resPair._2();

		if (rawResult.isDefined()) {
			final Result rawResult2 = rawResult.get();
			if ((rawResult2 instanceof NoCounterModel$)
					|| (rawResult2 instanceof Proof)
					|| (rawResult2 instanceof ProofWithModel)
					|| (rawResult2 instanceof Model)) {
				result.isProven = true;
			} else {
				result.isProven = false;
				if (rawResult2 instanceof CounterModel) {
					final CounterModel rawResult3 = (CounterModel) rawResult2;
					result.counterexample = DialogUtil$.MODULE$
							.asString(new scala.runtime.AbstractFunction0<Integer>() {
								public Integer apply() {
									PrincessLineariser$.MODULE$
											.printExpression(rawResult3
													.counterModel());
									return 0;
								}
							});
				}
			}
		} else {
			throw new PrincessFacadeException(
					"Cannot use prover PRINCESS: " + output);
		}

		return result;
	}

	private scala.Option<Result> proveCore(final String po, String problemName) {
		return CmdlMain.proveProblem(GlobalSettings.DEFAULT(), problemName,
				new scala.runtime.AbstractFunction0<java.io.Reader>() {
					public java.io.BufferedReader apply() {
						return new java.io.BufferedReader(
								new java.io.StringReader(po));
					}
				}, new scala.runtime.AbstractFunction0<Object>() {
					public Boolean apply() {
						return false;
					}
				}, Param.InputFormat$.MODULE$.Princess());
	}

	/**
	 * Princess offers a class <code>ap.SimpleAPI.ProverResult</code>, which
	 * might serve a similar purpose as this one, but have not checked yet.
	 * 
	 * @author BAAR
	 *
	 */
	public class PrincessFacadeResult {
		public boolean isProven = false;
		public String counterexample = ""; // only set when isProven==false
	}

	public class PrincessFacadeException extends Exception {

		private static final long serialVersionUID = -3582173752298851836L;

		public PrincessFacadeException(String message) {
			super(message);
		}

		public PrincessFacadeException(String message, Throwable throwable) {
			super(message, throwable);
		}

	}

}


