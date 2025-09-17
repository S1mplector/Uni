public interface EnemyAttacker {
    // This is the interface that the client expects to be working with
    // It will be the adapter's job to make any new classes we create work compatibly with THIS interface

    public void fireWeapon();
    public void driveForward();
    public void assignDriver(String driverName);

}