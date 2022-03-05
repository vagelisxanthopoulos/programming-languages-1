import java.util.*;
import java.lang.Cloneable;
import java.io.File; // Import the File class
import java.io.FileNotFoundException; // Import this class to handle errors
import java.util.Scanner; // Import the Scanner class to read text files

//kanonas: se mia poli boroun na synandithoun ola ta autokinita
//         an kai mono an i megisti apostasi autokinitou apo tin poli
//         einai mikroteri i isi tou athroismatos twn ypoloipwn apostasewn + 1
//an isxyei o kanonas yparxei diamerisi kinisewn, alliws tha xreiazontai synexomenes kiniseis

//opote gia kathe poli theloume athroisma apostasewn kai megisti apostasi

//to athroisma apostaswn mias polis to vriskoume apo to proigoumeno ws eksis:
//ta autokinita pou vriskontai stin poli apexoun apostasi cities-1 apo tin proigoumeni
//opote apo to proigoumeno athroisma afairoume (cities - 1)*ta autokinita tis polis
//kai gia ta ypoloipa autokinita prosthetoume 1 (apexoun ena vima parapanw)
//ara S(n)=S(n-1) - a*(cities - 1) + (k-a)*1, opou "a" ta autokinita tis polis n kai "k" ta synolika autokinita
//O pinakas me ta autokinita ana poli ftiaxnetai se polyplokotita K
//I synoliki apostasi gia tin prwti poli ftiaxnetai se polyklokotita K
//oi ypoloipes synolikes apostaseis vriskontai me polylokotita N
//ara synolika N+K

//tin megisti apostasi pou exei kapoio amaksi apo mia poli tin vriskoume an vroume tin pio kodini tis (pros ta deksia) poli pou exei amaksi
//opote an diatreksoume mia fora anapoda ton pinaka me ta autokinita ana poli to vriskoume se polyplokotita N
//o pinakas me ta autokinita ana poli ftiaxnetai me poliplokotita K
//ara synolika N+k

//telos diatrexoume mia fora ton pinaka me athroisma kai megisto kai elegxoume tin synthiki
//kratame tin poli pou boroun na ftiasoun me ta ligotera vimata
//auto exei polyplokotita N
//ara olos o algorithmos N+K

public class Round {

    int[][] summaxpercity;
    int[] carspercity;
    int cars;
    int cities;

    public Round(String filename) {
        try {
            File f = new File(filename);
            Scanner reader = new Scanner(f);
            String str = reader.nextLine();
            String[] line = str.split("\\s+", 0);
            cities = Integer.parseInt(line[0]);
            cars = Integer.parseInt(line[1]);
            str = reader.nextLine();
            line = str.split("\\s+", 0);
            summaxpercity = new int[cities][2];
            carspercity = new int[cities];
            for (int i = 0; i < cities; i++)
                carspercity[i] = 0; // arxikopoiisi
            int loc;
            int totaldistfromcity0 = 0;
            int firstcitywithcar = cities;
            // kataskeui pinaka autokinitwn ana poli
            // euresi synolikis apostasis gia prwti poli
            // euresi kodinoteris polis (apo deksia) gia to teleutaio stoixeio
            for (int i = 0; i < cars; i++) {
                loc = Integer.parseInt(line[i]);
                if (loc != 0)
                    totaldistfromcity0 += cities - loc;
                carspercity[loc] += 1;
                if (loc < firstcitywithcar)
                    firstcitywithcar = loc;
            }

            // euresi sinolikwn apostasewn gia kathe poli (sum -> deiktis 0)
            summaxpercity[0][0] = totaldistfromcity0;
            for (int i = 1; i < cities; i++) {
                summaxpercity[i][0] = summaxpercity[i - 1][0] - carspercity[i] * (cities - 1) + (cars - carspercity[i]);
            }

            // euresi megistwn apostaswn apo kathe poli (max -> deiktis 1)

            summaxpercity[cities - 1][1] = cities - 1 - firstcitywithcar;
            int nearestcity = firstcitywithcar;
            for (int i = cities - 2; i >= 0; i--) {
                if (carspercity[i + 1] > 0)
                    nearestcity = i + 1;
                if (i - nearestcity >= 0)
                    summaxpercity[i][1] = i - nearestcity;
                else
                    summaxpercity[i][1] = cities + (i - nearestcity);
            }

            reader.close();
        } catch (FileNotFoundException e) {
            System.out.println("An error occurred.");
        }
    }

    public static void main(String args[]) {
        Round input = new Round(args[0]);
        boolean first = true;
        int meetcity = 0;
        int meetsteps = 0;
        int sum, max;
        for (int i = 0; i < input.cities; i++) {
            sum = input.summaxpercity[i][0];
            max = input.summaxpercity[i][1];
            if (max <= sum - max + 1) {
                if (first || sum < meetsteps) {
                    meetcity = i;
                    meetsteps = sum;
                }
                first = false;
            }
        }
        System.out.print(meetsteps);
        System.out.print(" ");
        System.out.print(meetcity);
        System.out.println();
    }
}