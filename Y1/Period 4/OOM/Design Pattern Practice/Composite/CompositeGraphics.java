import java.util.ArrayList;
import java.util.List;

public class CompositeGraphics implements Graphics {

    // Collection to store child components
    private final List<Graphics> children = new ArrayList<>();

    // Method to add a child graphic
    public void add(Graphics graphic) {
        children.add(graphic);
    }

    // Method to remove a child graphic
    public void remove(Graphics graphic) {
        children.remove(graphic);
    }

    // The composite draw() method delegates drawing to each child
    @Override
    public void draw() {
        for (Graphics graphic : children) {
            graphic.draw();
        }
    }
}
