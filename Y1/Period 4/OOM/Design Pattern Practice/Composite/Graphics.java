/**
 * The Graphics class will be the component interface
 * Both leaves and composite objects will implement this interface
 * We'll have a common method like draw()
 */

public interface Graphics {

    /**
     * Imagine we're designing a graphics application
     * where we have individual shapes: circles, squares
     * 
     * But we also want to be able to draw groups of shapes together
     * (like makybe a circle in a square)
     * 
     * And we want to be able to apply the same operations 
     * such as drawing or moving to both individual shapes and groups of shapes
     */

    void draw();


}
