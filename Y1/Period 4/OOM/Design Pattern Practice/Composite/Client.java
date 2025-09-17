public class Client {
    public static void main(String[] args) {
        // Create leaves
        Graphics circle = new Circle();
        Graphics square = new Square();

        // Create a composite and add leaves to it
        CompositeGraphics drawing = new CompositeGraphics();
        drawing.add(circle);
        drawing.add(square);

        // The client calls draw on the composite without worrying about the individual objects.
        drawing.draw();
    }
}