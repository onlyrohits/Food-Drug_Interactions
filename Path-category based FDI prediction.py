#!/usr/bin/env python
# coding: utf-8

# In[4]:


import numpy as np
import pandas as pd
df = pd.read_csv("F:\STFX\Biomedical Computation\Project\drug_food_threshhold_similarity.csv")
df.head()


# In[5]:


df['query'].value_counts()


# In[6]:


df['target'].value_counts()


# In[11]:


allvalues = list(set(df['query'].unique())|(set(df['target'].unique())))
dic = {}
for i in range(len(allvalues)):
    dic[allvalues[i]] = i
g = []
for i in range(2000):
    g.append([])
    


# In[12]:


for row in df.iterrows():
    x = dic[row[1][0]]
    y = dic[row[1][1]]
    z = row[1][2]
    g[x].append((y,z))
    g[y].append((x,z))


# In[13]:


pa = []
si = []
for i in range(2000):
    pa.append(i)
    si.append(1)


# In[14]:


def findpa(x):
    global pa
    if(x==pa[x]):
        return x
    else:
        pa[x]=findpa(pa[x])
        return pa[x]


# In[15]:


for row in df.iterrows():
    global pa
    x = dic[row[1][0]]
    y = dic[row[1][1]]
    x = findpa(x)
    y = findpa(y)
    if(x!=y):
        if(x>y):
            pa[x]=y
            si[y]+=si[x]
        else:
            pa[y]=x
            si[x]+=si[y]


# In[16]:


li = []
cnt = 0
cnt2 = 0
for i in range(len(allvalues)):
    if(pa[i]==i):
        cnt+=1
        if(si[i]==2):
            cnt2+=1
        print(i,si[i])
print(cnt)
print(cnt2)


# In[17]:


print(len(allvalues))


# In[18]:


gg = []
for i in range(len(allvalues)):
    gg.append([])
    for j in range(len(allvalues)):
        gg[i].append(0)
    gg[i][i]=1
    for val in g[i]:
        gg[i][val[0]] = val[1]


# In[19]:


res_path = gg
gg_new = gg
g_new = g
new_pair = []


# In[20]:


#maxsim(a,c) = 1-|sim(a,b)-sim(b,c)|
#minsim(a,c) = max(0,sim(a,b)+sim(b,c)-1)
#sim(a,c) = (maxsim+minsim)/2

sets = []
for i in range(len(allvalues)):
    tmp = []
    for x in g[i]:
        tmp.append(x[0])
    sets.append(set(tmp))
#N = 3
for i in range(len(allvalues)):
    si = sets[i]
    for j in range(i+1,len(allvalues)):
        if(gg[i][j]!=0):
            continue
        si2 = sets[j]
        z = si.intersection(si2)
        if(len(z)!=0):
            sumsim = 0
            for x in z:
                maxsim = (1-abs(gg[i][x]-gg[x][j]))
                minsim = (max(0,gg[i][x]+gg[x][j]-1))
                avgsim = (maxsim+minsim)/2
                sumsim+=avgsim
            sm = sumsim/len(z)
            res_path[i][j]=sm
            res_path[j][i]=sm
            new_pair.append((i,j,sm))
print(np.count_nonzero(res_path))


# In[30]:


print(np.count_nonzero(gg_new))
print(len(new_pair))


# In[31]:


qu = []
tar = []
val = []
for i in range(len(allvalues)):
    for j in range(i+1,len(allvalues)):
        if(res_path[i][j]!=0):
            if(allvalues[i] in df['query']):
                qu.append(allvalues[i])
                tar.append(allvalues[j])
            else:
                qu.append(allvalues[j])
                tar.append(allvalues[i])
            val.append(res_path[i][j])


# In[32]:


df_new = pd.DataFrame(zip(qu,tar,val),columns = ['query','target','value'])


# In[37]:


df_new.tail()


# In[35]:


df_new.to_csv("F:\STFX\Biomedical Computation\Project\path-category-based-similarity.csv")


# In[ ]:




