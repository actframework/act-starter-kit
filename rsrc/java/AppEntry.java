package PackageName;

import act.Act;
import act.inject.DefaultValue;
import act.util.Output;
import org.osgl.mvc.annotation.GetAction;

@SuppressWarnings("unused")
public class AppEntry {

    @GetAction
    public void home(@DefaultValue("Hello Act") @Output String msg) {
    }

    public static void main(String[] args) throws Exception {
        Act.start();
    }

}
