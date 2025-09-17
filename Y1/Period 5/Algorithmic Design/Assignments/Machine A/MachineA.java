import java.io.*;
import java.util.*;

public class MachineA {
    public static void main(String[] args) throws IOException {
        Scanner scanner = new Scanner(System.in);
        
        // Read the filename from standard input (no prompts).
        String filename = scanner.nextLine();
        File infile = new File(filename);
        Scanner input = new Scanner(infile);

        // Read the number of tasks (k).
        int k = input.nextInt();
        Task[] tasks = new Task[k];

        // Read the k tasks: start, end.
        for (int i = 0; i < k; i++) {
            int start = input.nextInt();
            int end = input.nextInt();
            tasks[i] = new Task(start, end);
        }
        input.close();

        // Sort tasks first by start time, then by duration (end - start).
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

        // Greedy scheduling:
        ArrayList<Task> scheduled = new ArrayList<>();
        int currentTime = 0;
        int i = 0;

        while (i < tasks.length) {
            // Skip tasks that start before currentTime
            if (tasks[i].start < currentTime) {
                i++;
                continue;
            }

            // If the next task starts after currentTime, jump currentTime forward
            if (tasks[i].start > currentTime) {
                currentTime = tasks[i].start;
            }

            // Schedule the task
            Task chosen = tasks[i];
            scheduled.add(chosen);
            currentTime = chosen.end;

            // Skip tasks that start before 'currentTime'
            while (i < tasks.length && tasks[i].start < currentTime) {
                i++;
            }
        }

        // Print only the scheduled tasks (one line per task).
        for (Task t : scheduled) {
            System.out.printf("%d %d\n", t.start, t.end);
        }

        scanner.close();
    }

    // Helper class for tasks.
    static class Task {
        int start, end;
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
