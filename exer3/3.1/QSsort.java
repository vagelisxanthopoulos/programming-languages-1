import java.util.*;
import java.lang.Cloneable;
import java.io.File; // Import the File class
import java.io.FileNotFoundException; // Import this class to handle errors
import java.util.Scanner; // Import the Scanner class to read text files

public class QSsort {

    ArrayDeque<Integer> queue;
    ArrayDeque<Integer> stack;
    String moves ;
    String que;  //tha exoume oura kai stiva se morfi string gia to hashset (ta enwnnoume kai ta apothikeuoume)
    String stk;
    int lastS = -1; //exoume mi arnitikous arithmous opote apokleietai kapoios na einai -1

    // constructor apo eisodo
    public QSsort(String filename){
        int temp, totalnums;
        queue = new ArrayDeque<Integer>();
        stack = new ArrayDeque<Integer>();
        moves = "";
        stk = "";
        que = "";
        try {
            File f = new File(filename);
            Scanner reader = new Scanner(f);
            String str = reader.nextLine();
            String[] line = str.split("\\s+", 0);
            totalnums = Integer.parseInt(line[0]);
            str = reader.nextLine();
            line = str.split("\\s+", 0);
            for (int i = 0; i < totalnums; i++){
                if (i != totalnums - 1) que += line[i] + " ";
                else que += line[i];
                temp = Integer.parseInt(line[i]);
                queue.addLast(temp);
            }
            reader.close();
        } 
        catch (FileNotFoundException e) {
            System.out.println("An error occurred.");
        }
    }

    //copy contructor 
    public QSsort(QSsort copy){
        this.queue = copy.queue.clone();
        this.stack = copy.stack.clone();
        this.moves = copy.moves;
        this.que = copy.que;
        this.stk = copy.stk;
        this.lastS = copy.lastS;
    }

    //epistrefei neo state kai ftiaxnei tin anaparastasi twn stack kai queue se strings
    //kratame to stack kai queue ws strings gia na boroume na ta hasharoume
    //wste na kseroume an ta exoume ksanadei
    public QSsort Qmove(){
        QSsort copy = new QSsort(this);
        copy.stack.addFirst(copy.queue.pop()); //i pop vgazei kai epistrefei to prwto
        copy.moves = copy.moves + "Q";
        //vrisoume prwto keno (an i oura exei ena stoixeio tote den yparxei keno kai synepws menei adeia)
        int firstspace = 0;
        boolean found = false;
        while (!found && firstspace < copy.que.length()) {
            if (copy.que.charAt(firstspace) != ' ') firstspace ++;
            else found = true;
        }
        //to first einai to kommati tou string tis ouras pou tha vgei
        //an i oura exei ena stoixeio tote menei to keno string alliws menei i ypoloipi
        String first = copy.que.substring(0, firstspace); //to deutero orisma tis substring den perilamvanetai, paei mexri ena prin
        if (firstspace != copy.que.length()) copy.que = copy.que.substring(firstspace + 1);
        else copy.que = "";
        //an i stiva itan adeia apla ginetai isi me first, alliws prosthetoume to first mazi me keno
        if (copy.stk != "") copy.stk = first + " " + copy.stk;
        else copy.stk = first;
        return copy;
    }
    
    //omoiws me panw
    public QSsort Smove(){
        QSsort copy = new QSsort(this);
        copy.queue.addLast(copy.stack.pop());
        copy.moves = copy.moves + "S";
        int firstspace = 0;
        boolean found = false;
        while (!found && firstspace < copy.stk.length()) {
            if (copy.stk.charAt(firstspace) != ' ') firstspace ++;
            else found = true;
        }
        String first = copy.stk.substring(0, firstspace);
        if (firstspace != copy.stk.length()) copy.stk = copy.stk.substring(firstspace + 1);
        else copy.stk = "";
        if (copy.que != "") copy.que = copy.que + " " + first;
        else copy.que = first;
        copy.lastS = copy.queue.getLast();
        return copy;
    }


    //elegxoume an oura sortarismeni
    public boolean success(){
        Iterator itr = queue.iterator();
        int previous = 0;
        int current = 0;
        if (itr.hasNext()) previous = (int)itr.next();
        while (itr.hasNext()){
            current = (int)itr.next();
            if (current < previous) return false;
            previous = current;
        }
        return true;
    }

    //epistrefei oura me tis epomenes katastaseis
    public ArrayDeque<QSsort> nextStates (){
        ArrayDeque<QSsort> ret = new ArrayDeque<QSsort>();
        if (queue.isEmpty()){ //adeia oura -> kanoume S
            ret.addLast(this.Smove());
        } 
        else if (stack.isEmpty()){ //adeia stiva -> kanoume Q
            ret.addLast(this.Qmove());
        }
        //prwto stivas = prwto ouras -> kanoume Q (kratame idia mazi)
        else if (stack.getFirst() == queue.getFirst()){
            ret.addLast(this.Qmove());
        }
        //prwto stivas = teleutaio pou kaname S -> kanoume S (kratame idia mazi)
        else if (stack.getFirst() == lastS){
            ret.addLast(this.Smove());
        }
        else{
            ret.addLast(this.Qmove());
            ret.addLast(this.Smove());
        }
        return ret;
    }

    public static void main(String args[]) {
        HashSet<String> seen = new HashSet<String>();
        ArrayDeque<QSsort> States = new ArrayDeque<QSsort>(); //oura katastasewn pou prepei na tsekaristoun
        ArrayDeque<QSsort> nextstates; //oura epomenwn katastasewn apo auti pou exoume
        QSsort orig = new QSsort(args[0]); //arxiki katastasi
        States.addLast(orig);  //vazoume tin arxiki katastasi stis katastaseis mas
        int movescnt = 0;    //arxika eimaste stis miden kiniseis
        QSsort currstate;
        String answer = "";
        boolean finished = false;
        
        if (orig.success()){
            finished = true;
            answer = "empty";
        }

        //apo kathe katastasi vriskoume kai elegxoume tis epomenes katastaseis kai kratame mono orismenes (oses den exoume ksanadei) gia na kanoume to idio
        while(!finished){
            currstate = States.pop();
            if (currstate.moves.length() == movescnt + 1){  //adeiazoume to synolo otan mas dinei pliroforia mono gia ligoteres kiniseis
                movescnt += 1;
                seen.clear();
            }
            nextstates = currstate.nextStates(); //oura epomenwn katastasewn
            int size = nextstates.size();
            while (size != 0 && !finished){  //elegxw tis epomenes katastaseis
                size--;
                QSsort next = nextstates.pop();
                String data = next.que + "I" + next.stk;
                
                //an kapoies allilouxies kinisewn (exoun idio plithos kinisewn logw tou clear pou kanoume panw)
                //exoun idia katastasi stivas-ouras tote kratame mono tin prwti giati einai i leksikografika mikroteri

                if (!seen.contains(data)){   
                    if (next.stack.isEmpty()){
                        if (next.success()){  //elegxoume mono an to petyxainoume prwti fora kai exoume adeia stiva y
                            finished = true;
                            answer = next.moves;
                            break;
                        }
                    }
                    States.addLast(next); 
                    seen.add(data);       
                }
            }
        }
        System.out.println(answer);        
    }
}
