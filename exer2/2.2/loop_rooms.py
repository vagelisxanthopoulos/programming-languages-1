import sys

with open(sys.argv[1]) as f:
    gr, st = [int(x) for x in next(f).split()] # read first line
move = []
linecnt = 0
with open(sys.argv[1]) as f:
    for line in f:
        linecnt += 1
        if linecnt > 1 :
            for ch in line: 
                if ch != ' ' and ch != '\n' : move.append(ch)



nextone = []
cnt = 0
for x in move:
    if x == 'L' : nextone.append(cnt - 1)
    elif x == 'R' : nextone.append(cnt + 1)
    elif x == 'U' : nextone.append(cnt - st)
    else : nextone.append(cnt + st)
    if nextone[cnt] < 0 : nextone[cnt] = -1
    elif nextone[cnt] >= gr * st : nextone[cnt] = -1
    elif (x == 'R' or x == 'L') and ((nextone[cnt] // st) != (cnt // st)) : nextone[cnt] = -1
    cnt = cnt + 1
    


res = 0
fin = [0] * (st * gr)
vis = [0] * (st * gr)
notfin = [0] * (st * gr)

for x in range(st * gr) :
    if nextone[x] == -1 :
        vis[x] =  1
        fin[x] = 1
        
for x in range(st * gr) :
    if vis[x] == 1 : continue
    path = []
    temp = x
    while True:
        vis[temp] = 1
        path.append(temp)
        if fin[nextone[temp]] == 1 :
            for x in path :
                fin[x] = 1
            break
        elif notfin[nextone[temp]] == 1 or vis[nextone[temp]] == 1 :
            for x in path :
                notfin[x] = 1
                res += 1
            break
        else : temp = nextone[temp]
            
print(res)