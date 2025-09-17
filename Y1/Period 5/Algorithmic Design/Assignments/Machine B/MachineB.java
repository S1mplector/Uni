import java.io.*;
import java.util.Arrays;
import java.util.Comparator;
import java.util.Scanner;

public class MachineB {
    public static void main(String[] args) throws IOException {
        Scanner scanner = new Scanner(System.in);
        
          String filename = scanner.nextLine();
    File file = new File(filename);
    Scanner input = new Scanner(file);
    
    // Read the number of tasks.
    int k = input.nextInt();
    Task[] tasks = new Task[k];
    
    // Read the tasks: each task's start and finish time.
    for (int i = 0; i < k; i++) {
        int start = input.nextInt();
        int end = input.nextInt();
        tasks[i] = new Task(start, end);
    }
    input.close();
    
    // Sort tasks by finish time (ascending)
    Arrays.sort(tasks, new Comparator<Task>() {
        @Override
        public int compare(Task t1, Task t2) {
            return Integer.compare(t1.end, t2.end);
        }
    });
    
    // Greedy selection
    // Initialize the current finish time to 0
    int count = 0;
    int currentFinish = 0;
    // For each task, if it starts at or after the current finish time
    // select it and update currentFinish
    for (int i = 0; i < k; i++) {
        if (tasks[i].start >= currentFinish) {
            count++;
            currentFinish = tasks[i].end;
        }
    }
    
    // Output the maximum number of scheduled tasks.
    System.out.println(count);
    scanner.close();
}

// Helper class to represent a task.
static class Task {
    int start;
    int end;
    
    public Task(int start, int end) {
        this.start = start;
        this.end = end;
    }
}
}

