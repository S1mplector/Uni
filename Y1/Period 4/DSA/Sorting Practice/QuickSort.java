

public class QuickSort {

    public static void main(String[] args) {
        
        // Unsorted array
        int[] array = {8,4,5,7,1,6,3,6,2,3,4,2};

        // Unsorted array
        for (int i : array) {
            System.out.print(i + " ");
        }

        // Apply quickSort() on the array
        quickSort(array, 0, array.length - 1);

        System.out.println();

        // Sorted array
        for (int i : array) {
            System.out.print(i + " ");
        }
        
    }

    // Our quickSort() method
    /**
     * There will be three arguments:
     * 1. Our array
     * 2. The beginning index of the array
     * 3. The ending index of the array
     */

    /**
     * 
     * @param array (Our array that we want to pass into the method)
     * @param start (The starting index)
     * @param end (The ending index)
     */
    private static void quickSort(int[] array, int start, int end) {

        // Base case: If the end is smaller than the start, return
        // This is our stopping condition!

        if (end <= start) {return;}

        // This will figure out where our pivot is going to be 
        int pivot = partition(array, start, end);

        // quickSort the left partition
        // pivot - 1 is the end of our left partition
        quickSort(array, start, pivot - 1);

        // quickSort the right partition
        quickSort(array, pivot + 1, end);

    }

    // Helper function

    /**
     * 
     * @param array (Our array that we want to pass into the method)
     * @param start (Starting index)
     * @param end (Ending index)
     * @return (Will return an integer that is the location of our pivot)
     */
    private static int partition(int[] array, int start, int end) {

        // In our implementation, we'll take the pivot as the end element
        int pivot = array[end];

        // We'll need our two indices, i and j
        // Remember, j is the starting index, i is one less than that

        int i = start - 1;

        for (int j = start; j <= end - 1 ; j++) {
            // Remember the condition:  

            // If j is greater or equal than the pivot, do nothing 
            // and just move j to the next index

            // If j is smaller than the pivot,
            // move i to the next index, and 

            if (array[j] <= pivot) {
                // If the current j is less than the pivot
                // We want it at the left side of our pivot
                // Increment i by one, do a basic variable swap

                i++;

                int temp  = array[i]; // Make a placeholder and store i
                array[i] = array[j]; // j is now in place of i
                array[j] = temp; // temp (which is i) is now in place of j

            }

        }

        // Inserting pivot into it's final resting place
        i++;
        int temp  = array[i]; // Make a placeholder and store i
        array[i] = array[end]; // j is now in place of i
        array[end] = temp; // temp (which is i) is now in place of j

        return i; // location of our pivot

    }

}