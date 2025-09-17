import java.util.Random;

public class EnemyRobot {
    
    // This is the adaptee class, the class that we want to be able to work with the client

    Random generator = new Random();

    public void smashThingsWithHands() {

        // It doesn't fire a weapon in the usual way, it smashes with it's hands
        int attackDamage = generator.nextInt(10) + 1;
        System.out.println("Enemy robot causes " + attackDamage + " damage with it's hands!");

    }

    public void walkForward() {

        // It doesn't drive, it walks forward

        int movement = generator.nextInt(5) + 1; 
        System.out.println("Enemy robot walks forward by " + movement + " units!");

    } 

    public void reactToHuman(String driverName) {
        System.out.println("Enemy robot tramps on " + driverName);
    }
    

}
