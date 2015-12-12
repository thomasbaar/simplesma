package de.htwberlin.selab.princessintegration;

import static org.junit.Assert.*;

import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;

import de.htwberlin.selab.princessintegration.PrincessFacade.PrincessFacadeException;
import de.htwberlin.selab.princessintegration.PrincessFacade.PrincessFacadeResult;

public class PrincessFacadeTest {
	
	
	// examples for proof-obligations (prover input)
	static final String inpProvable_1 = "\\universalConstants { int collected; int bill;} \\problem{((true & (collected = (bill - 1))) -> true)} ";
	static final String inpNonProvable_1 = "\\universalConstants { int collected; int bill;} \\problem{((true & (collected = (bill - 1))) -> false)} ";
	static final String inpSyntaxError_1 = "\\universalConstants { int collected; int bill;} \\problem{((true & (colected = (bill - 1))) -> false)} ";
	static final String inpProvableExists_1 = "\\existentialConstants  { int c;} \\problem{(c <5 & c > 3)} ";
	static final String inpNonProvableExists_1 = "\\existentialConstants  { int c;} \\problem{(c <4 & c > 3)} ";
	
	
	static PrincessFacade out;
	
	// results of a prover call are written in an result-object
	PrincessFacadeResult result;

	@BeforeClass
	public static void setUpBeforeClass() throws Exception {
		out = new PrincessFacade();
	}

	@AfterClass
	public static void tearDownAfterClass() throws Exception {
	}

	@Before
	public void setUp() throws Exception {
		result = null;
	}

	@After
	public void tearDown() throws Exception {
	}

	
	
	@Test
	public void testProvable() throws Exception{
		result = out.prove(inpProvable_1, "Provable PO");
		assertTrue(createInfoMsg("Provable input has not been proven"), result.isProven);
	}
	
	@Test
	public void testProvableExists() throws Exception{
		result = out.prove(inpProvableExists_1, "Provable PO");
		assertTrue(createInfoMsg("Provable input has not been proven"), result.isProven);
	}
	
	// at the beginning, we had problems to prove the same thing twice
	@Test
	public void testProvableAgain() throws Exception{
		result = out.prove(inpProvable_1, "Provable PO1");
		assertTrue(createInfoMsg("Provable input has not been proven"), result.isProven);
	}
	
	
	
	private String createInfoMsg(String prefix){
//		return prefix + ";  Result.out:  " + result.outmsg + "; Result.err: " + result.errmsg; 
		return prefix;
	}
	
	
	@Test
	public void testNonProvable() throws Exception{
		result = out.prove(inpNonProvable_1, "NonProvable PO");
		assertFalse(createInfoMsg("Nonprovable input has  been proven"), result.isProven);
		assertEquals("Unexpected countermodel", "bill = 1 & collected = 0", result.counterexample);
//		System.out.println("Countermodel: " + result.counterexample);
	}
	
	@Test
	public void testNonProvableExists() throws Exception{
		result = out.prove(inpNonProvableExists_1, "NonProvableExists PO");
		assertFalse(createInfoMsg("Nonprovable input has  been proven"), result.isProven);
		assertEquals("Unexpected countermodel", "true", result.counterexample);  //there is no useful counter-example
	}
	
	@Test(expected=PrincessFacadeException.class)
	public void testSyntaxError() throws Exception{
		try{
		result = out.prove(inpSyntaxError_1, "SyntaxError PO");
		}catch (PrincessFacadeException e){
			String excMsg = e.getMessage();
//			System.out.println("Exception message: " + e.getMessage());
//			System.out.println("End of Exception message");
			assertEquals("Unexpected exception message", "Cannot use prover PRINCESS: ERROR: Symbol colected not declared", excMsg.trim());
			throw e;
		}
		fail("Exception expected");
	}
	
	@Test(expected=PrincessFacadeException.class)
	public void testSyntaxErrorAgain() throws Exception{
		try{
		result = out.prove(inpSyntaxError_1, "SyntaxError PO");
		}catch (PrincessFacadeException e){
			String excMsg = e.getMessage();
//			System.out.println("Exception message: " + e.getMessage());
//			System.out.println("End of Exception message");
			assertEquals("Unexpected exception message", "Cannot use prover PRINCESS: ERROR: Symbol colected not declared", excMsg.trim());
			throw e;
		}
		fail("Exception expected");
	}
	

	

}
