package ssma.sminvcb.adapter;

import java.util.List;

/**
 * Adapter for accessing from statemachine to application 
 * (i.e. the implemented system modeled by statemachine)
 * 
 * Note that all implementing classes are required to have a
 * parameterless constructor.
 * 
 * @author baar
 *
 */
public interface IAppAdapter {
	
	/**
	 * Creates adaptee object and initializes everything.
	 * @param sm - the object to communicate the occurrences of events 
	 */
	void init(ISmAdapter sm);
	
	/**
	 * Starts the application
	 */
	void start();
	
	/**
	 * Getter for code-variable
	 * @param varName
	 * @return
	 */
	int getVal(String varName);
	
	/**
	 * Passing a message string for debug-purposes.
	 * @param msg
	 */
	void debug(String msg);
	
	/** 
	 * Overrides the list of events to be execute for the driver
	 * @param evl
	 */
	void setEventList(List<String> evl);

}
