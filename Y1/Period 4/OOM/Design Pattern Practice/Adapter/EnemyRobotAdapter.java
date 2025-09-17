public class EnemyRobotAdapter implements EnemyAttacker {

    // As we're implementing the target interface, we need to implement all the methods in it

    // Store an instance of the adaptee inside the adapter

    EnemyRobot theRobot = new EnemyRobot();

    public EnemyRobotAdapter(EnemyRobot newRobot) {
        theRobot = newRobot;
    }

    @Override
    public void fireWeapon() {

        theRobot.smashThingsWithHands();

    }

    @Override
    public void driveForward() {

        theRobot.walkForward();

    }

    @Override
    public void assignDriver(String driverName) {

        theRobot.reactToHuman(driverName);

    }

}