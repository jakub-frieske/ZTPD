import com.espertech.esper.common.client.EventBean;
import com.espertech.esper.runtime.client.EPRuntime;
import com.espertech.esper.runtime.client.EPStatement;
import com.espertech.esper.runtime.client.UpdateListener;

public class ProstyListener implements UpdateListener {

    @Override
    public void update(EventBean[] newEvents, EventBean[] oldEvents, EPStatement epStatement, EPRuntime epRuntime) {
        if (newEvents != null) {
            for (int i = 0; i < newEvents.length; i++) {
                System.out.println("ISTREAM : " + newEvents[i].getUnderlying());
            }
        }
        if (oldEvents != null) {
            for (int i = 0; i < oldEvents.length; i++) {
                System.out.println("RSTREAM : " + oldEvents[i].getUnderlying());
            }
        }
    }
}
