# implementation of queue stack problem
# make a class state with a queue and a stack 
# exhaustive search algo with BFS traversal to find the best solution

from os import read
import sys
from collections import deque

# CLASS STATE 
class state:
    def __init__(self, qu, stak, moves):
        self.qu = qu
        self.stak = stak
        self.moves = moves
    
    def __str__(self):
        return "qu : {}, stak : {}, moves : {}".format(
            "".join(str(self.qu)), "".join(str(self.stak)), "".join(self.moves))
    
    def __hash__(self):
        return hash((self.qu, self.stak))

    def q_move(self):
        qFirst = self.qu[0]
        newQ = self.qu[1:]
        newS = self.stak + (qFirst,)
        newM = self.moves + "Q"
        return state(newQ, newS, newM)

    def s_move(self):
        sLast = self.stak[-1]
        newQ = self.qu + (sLast,)
        newS = self.stak[:-1]
        newM = self.moves + "S"
        return state(newQ, newS, newM)


    def nxt_move(self):
        if (len(self.qu) == 0):
            yield self.s_move()
        elif (len(self.stak) == 0):
            yield self.q_move()
        else:
            yield self.q_move()
            yield self.s_move()
    
    def success(self):
        if not self.stak:                       
            if (self.qu == tuple(sorted(self.qu))):
                return True
        return False


def solve(ftup):                        #apo kathe katastasi vriskoume tis epomenes katastaseis kai kratame mono orismenes gia na kanoume to idio
    init = state(ftup, (), "")          
    min = ftup[0]
    for elem in ftup:
        if elem < min: 
            min = elem
    Q = deque([init])
    seen = set()                      
    movescnt = len(init.moves)
    while True:
        s = Q.popleft()
        if len(s.moves) == movescnt + 1:  #adeiazoume to synolo otan mas dinei pliroforia mono gia ligoteres kiniseis (axristes plirofories)
            movescnt += 1
            seen.clear()
        for t in s.nxt_move():
            if len(t.stak) == 0 and t.qu[0] == min:  #elegxoume mono me adeia stiva kai to minimum stin arxi
                if t.success():
                    return t.moves
            if (t.qu, t.stak) not in seen:  #an kapoies allilouxies kinisewn (exoun idio plithos kinisewn logw tou clear pou kanoume panw) 
                Q.append(t)                 #exoun idia katastasi stivas-ouras tote kratame mono tin prwti giati einai i leksikografika mikroteri
                seen.add((t.qu, t.stak))

def readfile(file):
    with open(file) as f:
        _ = f.readline()
        t = f.readline().split()
    return tuple(map(int, t[:]))

file = str(sys.argv[1])

if (readfile(file) == tuple(sorted(readfile(file)))):
    print("empty")
else:
    print(solve(readfile(file)))