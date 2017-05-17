package PackageName.ProjectName;

import act.Act;
import org.osgl.mvc.annotation.GetAction;
import static act.controller.Controller.Util.render;

@SuppressWarnings("unused")
public class Application {

    @GetAction("/")
    public void home() {
        String output = "hello world";
        render(output);
    }

    public static void main(String[] args) throws Exception {
        Act.start("ProjectName");
    }
}
