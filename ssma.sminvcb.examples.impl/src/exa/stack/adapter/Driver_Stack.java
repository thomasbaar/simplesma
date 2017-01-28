package exa.stack.adapter;

import java.util.List;

import ssma.sminvcb.adapter.ISmAdapter;
import exa.stack.app.Item;
import exa.stack.app.Stack1;

/**
 * This class has two responsibilities:
 * - driving the Stack-object according to the passed list of events 
 * - reporting to ISmAdapter, which events actually occurred
 * @author baar
 *
 */

// TODO: make a template class for this?
public class Driver_Stack {

	private static int CNT = 0;

	private Stack1 target;
	ISmAdapter sm;
	private int delayInms;
	private List<String> eventList;

	private static int nextCnt() {
		return CNT++;
	}

	public Driver_Stack(Stack1 target, ISmAdapter sm) {
		this(target, sm, 500);
	}

	public Driver_Stack(Stack1 target, ISmAdapter sm, int delay) {
		this.target = target;
		this.sm = sm;
		this.delayInms = delay;
	}

	public void setEventList(List<String> evl) {
		eventList = evl;
	}

	public void start() {
		for (String ev : eventList) {
			// informing the statemachine about the coming event
			sm.evOccurred(ev); //still reported in the pre-state
			
			switch (ev) {
			case "push":
				doPush();
				break;
			case "pop":
				doPop();
				break;
			default:
				throw new IllegalArgumentException("Unknown event " + ev);
			}
			System.out.println("Driver called" + ev);
			delay();
		}
	}

	private void doPush() {
		target.push(new Item("label_" + nextCnt()));
	}

	private void doPop() {
		target.pop();
	}

	private void delay() {
		try {
			Thread.sleep(delayInms);
		} catch (InterruptedException e) {
			e.printStackTrace();
			Thread.currentThread().interrupt();
		}
	}

}
