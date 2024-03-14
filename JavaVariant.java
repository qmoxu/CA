import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.Scanner;

public class JavaVariant {
    public static void main(String[] args) throws IOException {
            Scanner scanner = new Scanner(System.in);
            BufferedReader reader = new BufferedReader(new FileReader("/Users/qmocu/CompArchRepo/CompArch/test.txt"));
            String line;
            String foundWord = scanner.nextLine();
            int countLines = 0;

            int c = 0;
            while (reader.readLine() != null) {
                c++;
            }

            reader.close();

            reader = new BufferedReader(new FileReader("/Users/qmocu/CompArchRepo/CompArch/test.txt"));
            int[][] unsorted = new int[c][2];

            while ((line = reader.readLine()) != null) {
                int occurrences = numOfWords(line, foundWord);
                unsorted[countLines][0] = occurrences;
                unsorted[countLines][1] = countLines;
                countLines++;
            }
            bubbleSort(unsorted);
            for (int i = 0; i < countLines; i++) {
                System.out.println( unsorted[i][0] + " " + unsorted[i][1]);
            }
        }

        private static int numOfWords(String line, String targetPhrase) {
            int occurrences = 0;
            int index = line.indexOf(targetPhrase);
            while (index != -1) {
                occurrences++;
                index = line.indexOf(targetPhrase, index + targetPhrase.length());
            }
            return occurrences;
        }

        public static void bubbleSort(int[][] arr) {
            int n = arr.length;
            for (int i = 0; i < n - 1; i++) {
                for (int j = 0; j < n - i - 1; j++) {
                    if (arr[j][0] > arr[j + 1][0]) {
                        int[] temp = arr[j];
                        arr[j] = arr[j + 1];
                        arr[j + 1] = temp;
                    }
                }
            }
        }
}
