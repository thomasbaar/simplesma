package exa.stack.adapter;

import java.util.Arrays;
import java.util.List;

import ssma.sminvcb.adapter.IAppAdapter;
import ssma.sminvcb.adapter.ISmAdapter;
import exa.stack.app.Stack1;

public class AppAdapter_Stack implements IAppAdapter{
	
	private Driver_Stack driver;
	private Stack1 adaptee;

	@Override
	public void init(ISmAdapter sm) {
		adaptee = new Stack1();
		driver = new Driver_Stack(adaptee,sm);
		//TODO: make this is call from outside
		driver.setEventList(Arrays.asList("push", "pop", "push", "push", "pop", "push", "pop", "pop", "push", "pop" ));
	}

	@Override
	public void start() {
		driver.start();
	}

	@Override
	public int getVal(String varName) {
		switch (varName){
		case "c_s": return adaptee.getLength();
		default: throw new IllegalArgumentException("unknown varname " + varName);
		}
	}

	@Override
	public void debug(String msg) {
		System.out.println("Message from AppAdapter_Stack: " + msg);
	}

	@Override
	public void setEventList(List<String> evl) {
		driver.setEventList(evl);
		
	}

}
