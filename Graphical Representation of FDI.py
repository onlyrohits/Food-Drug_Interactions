#!/usr/bin/env python
# coding: utf-8

# In[16]:


import networkx as nx
import csv
import matplotlib.pyplot as plt
from networkx.drawing.nx_agraph import graphviz_layout

G = nx.Graph()

with open(r"F:\STFX\Biomedical Computation\Project\FDI.csv") as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=',')
    line_count = 0
    for row in csv_reader:
        if line_count == 0:
            line_count = 1
        else:
            if row[0] > row[1]:
                continue
            if float(row[2]) < 0.7:
                G.add_edge(row[0], row[1], color='#add8e6')
            elif float(row[2]) < 0.8:
                G.add_edge(row[0], row[1], color='#000086')
            else:
                G.add_edge(row[0], row[1], color='red')
                
            line_count += 1
        if line_count == 40:
            break
         
#pos = nx.graphviz_layout(G)

edges = G.edges()
colors = [G[u][v]['color'] for u,v in edges]
#nx.draw(G, node_size=10, with_labels=True, font_size=5, pos=graphviz_layout(G), edges=edges, edge_color=colors)
nx.draw_circular(G, node_size=10, with_labels=True, font_size=5, edges=edges, edge_color=colors)

plt.savefig(r"F:\STFX\Biomedical Computation\Project\FDI.pdf")
plt.show()


# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:




