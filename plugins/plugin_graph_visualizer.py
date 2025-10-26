import networkx as nx
from pyvis.network import Network
import os
G = nx.DiGraph()
plugins = ["csv_ingest", "sql_ingest", "auto_tagger", "benchmark", "registry", "cloner", "agent", "exporter", "sync", "loader"]
for i in range(len(plugins)-1): G.add_edge(plugins[i], plugins[i+1])
net = Network()
net.from_nx(G)
net.show(os.path.expanduser("~/ScrapeForge/export/plugin_graph.html"))
print("📊 Plugin graph visualized.")
