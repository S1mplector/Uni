import java.io.*;
import java.util.*;

public class MachineAVisual {
    public static void main(String[] args) throws IOException {
        Scanner scanner = new Scanner(System.in);

        // Read the filename from standard input.
        System.out.println("Enter the input filename:");
        String filename = scanner.nextLine();
        File infile = new File(filename);
        
        // Extra check: if the file doesn't exist, we show a message.
        if (!infile.exists()) {
            System.out.println("Error: File " + filename + " does not exist.");
            return;
        }
        
        Scanner input = new Scanner(infile);

        // Read the number of tasks k.
        if (!input.hasNextInt()) {
            System.out.println("Error: The file does not begin with an integer k.");
            input.close();
            return;
        }
        int k = input.nextInt();
        Task[] tasks = new Task[k];

        // Populate tasks array with start and end times.
        for (int i = 0; i < k; i++) {
            if (!input.hasNextInt()) {
                System.out.println("Error: Not enough integers (start) in input file for task #" + (i + 1));
                input.close();
                return;
            }
            int start = input.nextInt();

            if (!input.hasNextInt()) {
                System.out.println("Error: Not enough integers (end) in input file for task #" + (i + 1));
                input.close();
                return;
            }
            int end = input.nextInt();

            tasks[i] = new Task(start, end);
        }
        input.close();

        // Sort tasks by start time; if multiple tasks have the same start,
        // sort by ascending duration (end - start).
        Arrays.sort(tasks, new Comparator<Task>() {
            @Override
            public int compare(Task t1, Task t2) {
                if (t1.start != t2.start) {
                    return Integer.compare(t1.start, t2.start);
                } else {
                    return Integer.compare(t1.getDuration(), t2.getDuration());
                }
            }
        });

        // Greedy scheduling
        ArrayList<Task> scheduled = new ArrayList<>();
        int currentTime = 0;
        int i = 0;

        while (i < tasks.length) {
            // Skip tasks that start in the past compared to currentTime
            if (tasks[i].start < currentTime) {
                i++;
                continue;
            }

            // If the next task starts after the machine is free, jump currentTime to that start
            if (tasks[i].start > currentTime) {
                currentTime = tasks[i].start;
            }

            // Schedule the task starting now
            Task chosen = tasks[i];
            scheduled.add(chosen);
            currentTime = chosen.end;

            // Skip all tasks that start before 'currentTime'
            while (i < tasks.length && tasks[i].start < currentTime) {
                i++;
            }
        }

        // Print out how many were scheduled
        System.out.println("Number of tasks scheduled: " + scheduled.size());
        
        // Output scheduled tasks
        System.out.println("Scheduled tasks:");
        for (Task t : scheduled) {
            System.out.printf("%d %d\n", t.start, t.end);
        }

        scanner.close();
    }

    // Helper class to represent each task
    static class Task {
        int start;
        int end;
        int duration;

        public Task(int start, int end) {
            this.start = start;
            this.end = end;
            this.duration = end - start;
        }

        public int getDuration() {
            return duration;
        }
    }
}
