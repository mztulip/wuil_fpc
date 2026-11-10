import sys,struct,glob,collections
VT={0:'nul',1:'list',2:'i8',3:'i16',4:'i32',5:'ext',6:'str',7:'id',8:'false',9:'true',10:'bin',11:'set',12:'lstr',13:'nil',14:'coll'}
cls=collections.Counter(); props=collections.defaultdict(collections.Counter)
def val(d,p,out):
    t=d[p];p+=1
    if t in(2,):return struct.unpack('b',d[p:p+1])[0],p+1
    if t==3:return struct.unpack('<h',d[p:p+2])[0],p+2
    if t==4:return struct.unpack('<i',d[p:p+4])[0],p+4
    if t==5:return d[p:p+10],p+10
    if t in(6,7):n=d[p];return d[p+1:p+1+n].decode('latin1'),p+1+n
    if t in(8,9,13,0):return t==9,p
    if t==10:n=struct.unpack('<i',d[p:p+4])[0];return ('bin',n),p+4+n
    if t==11:
        s=[]
        while d[p]!=0:n=d[p];s.append(d[p+1:p+1+n].decode());p+=1+n
        return s,p+1
    if t==12:n=struct.unpack('<i',d[p:p+4])[0];return d[p+4:p+4+n],p+4+n
    if t==1:
        l=[]
        while d[p]!=0:v,p=val(d,p,out);l.append(v)
        return l,p+1
    if t==14:
        l=[]
        while d[p]!=0:
            if d[p]==1: p+=2 if False else 1  # index
            l.append(1)
            while d[p]!=0:
                n=d[p];p+=1+n;v,p=val(d,p,out)
            p+=1
        return 'coll',p+1
    raise Exception('vt %d at %d'%(t,p))
def obj(d,p,depth=0):
    n=d[p];c=d[p+1:p+1+n].decode();p+=1+n
    n=d[p];nm=d[p+1:p+1+n].decode();p+=1+n
    cls[c]+=1
    while d[p]!=0:
        n=d[p];pn=d[p+1:p+1+n].decode();p+=1+n
        v,p=val(d,p,None);props[c][pn]+=1
    p+=1
    while d[p]!=0:p=obj(d,p,depth+1)
    return p+1
for f in sorted(glob.glob('calmira_src/SRC/*.DFM')):
    d=open(f,'rb').read()
    i=d.index(b'TPF0')+4
    try:obj(d,i)
    except Exception as e:print(f,e)
print(len(cls),'classes');
for c,n in cls.most_common():print(c,n,len(props[c]),'props')
allp=set(p for c in props for p in props[c]);print(len(allp),'distinct prop names')
print(sorted(allp))
