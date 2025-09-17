public class QuickSortVerboseIndices {

    public static void main(String[] args) {
        // Unsorted array
        int[] array = {8,4,5,7,1,6,3,6,2,3,4,2};

        System.out.println("=== Original Array ===");
        printArray(array);

        // Call quickSort
        quickSort(array, 0, array.length - 1);

        System.out.println("\n=== Final Sorted Array ===");
        printArray(array);
    }

    /**
     * The main quickSort method
     *
     * @param array The array to sort
     * @param start The starting index
     * @param end   The ending index
     */
    private static void quickSort(int[] array, int start, int end) {
        if (start >= end) {
            return; // Base Case: subarray of length 1 or 0
        }

        // Partition the array and get the pivot index
        int pivotIndex = partition(array, start, end);

        // Recursively sort the left subarray
        quickSort(array, start, pivotIndex - 1);

        // Recursively sort the right subarray
        quickSort(array, pivotIndex + 1, end);
    }

    /**
     * Partition function that places the pivot element in its correct position
     * in the sorted array and places all smaller elements to the left of the pivot
     * and all greater elements to the right of the pivot.
     *
     * @param array The array to partition
     * @param start The starting index
     * @param end   The ending index
     * @return The final sorted position of the chosen pivot
     */
    private static int partition(int[] array, int start, int end) {
        int pivot = array[end]; // Choose the last element as pivot
        int i = start - 1;      // i will track the boundary for elements <= pivot

        System.out.println();
        System.out.println("-------------------------------------------------");
        System.out.println("Partitioning from index " + start + " to " + end);
        System.out.println("Chosen pivot = " + pivot + " (array[" + end + "])");
        printArray(array);

        for (int j = start; j <= end - 1; j++) {
            // Show current i, j for each iteration
            System.out.println("\n  [Iteration] Checking array[" + j + "] = " + array[j]
                               + " against pivot = " + pivot);
            System.out.println("  Current indices: i=" + i + ", j=" + j);

            // Compare current element to pivot
            if (array[j] <= pivot) {
                i++;
                System.out.println("    => array[" + j + "] <= " + pivot 
                                   + " => increment i => i=" + i 
                                   + " and swap array[" + i + "] with array[" + j + "]");
                swap(array, i, j);
                printArray(array);
                pause(600); // pause in milliseconds (adjust to taste)
            } else {
                // Show what happens when no swap occurs
                System.out.println("    => array[" + j + "] = " + array[j] 
                                   + " is > pivot (" + pivot + "), no swap.");
                pause(400);
            }
        }

        // Place the pivot in its correct spot
        int pivotIndex = i + 1;
        System.out.println("\nPlacing pivot " + pivot 
                           + " in final position at index " + pivotIndex);
        swap(array, pivotIndex, end);
        printArray(array);
        System.out.println("-------------------------------------------------\n");

        pause(800);
        return pivotIndex;
    }

    /**
     * Utility method to swap two elements in the array
     */
    private static void swap(int[] array, int i, int j) {
        if (i == j) return; // no need to swap an element with itself
        int temp = array[i];
        array[i] = array[j];
        array[j] = temp;
    }

    /**
     * Prints the entire array in a single line.
     */
    private static void printArray(int[] array) {
        StringBuilder sb = new StringBuilder();
        sb.append("[ ");
        for (int num : array) {
            sb.append(num).append(" ");
        }
        sb.append("]");
        System.out.println(sb.toString());
    }

    /**
     * Simple helper to pause between steps.
     * @param millis Number of milliseconds to sleep
     */
    private static void pause(long millis) {
        try {
            Thread.sleep(millis);
        } catch (InterruptedException e) {
            // ignore or handle differently if desired
            e.printStackTrace();
        }
    }
}
