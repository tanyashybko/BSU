import numpy as np

def find_max_matching(graph):
    colors = split_graph(graph)
    net = build_net(graph, colors)
    matching = []
    while True:
        path = find_dfs_path(net, 's', 't')
        if path is None:
            break
        net['s'].remove(path[1])
        net[path[-2]].remove('t')
        for i in range(1, len(path) - 2):
            net[path[i]].remove(path[i + 1])
            net[path[i + 1]].append(path[i])
            edge = tuple(sorted([path[i], path[i + 1]]))
            if edge in matching:
                matching.remove(edge)
            else:
                matching.append(edge)
    return matching

def dfs(graph, start_node, visited=None, from_=None):
    if visited is None:
        visited = set()
    if from_ is None:
        from_ = {key: None for key in graph.keys()}
        from_[start_node] = start_node
    visited.add(start_node)
    for neighbor in graph[start_node]:
        if neighbor not in visited:
            from_[neighbor] = start_node
            dfs(graph, neighbor, visited, from_)
    return visited, from_

def find_dfs_path(graph, start_node, end_node):
    _, from_ = dfs(graph, start_node)
    node = end_node
    path = []
    while True:
        if from_[node] is None:
            return None
        if from_[node] != node:
            path.append(node)
            node = from_[node]
        else:
            break
    path.append(start_node)
    return list(reversed(path))

def split_graph(graph):
    if len(graph) == 0:
        raise ValueError('graph should be non-empty dict')
    colors = {key: None for key in graph.keys()}

    def set_color(node):
        cur_color = colors[node]
        neighbor_color = 'r' if cur_color == 'l' else 'l'
        for g in graph[node]:
            if colors[g] is not None:
                if colors[g] != neighbor_color:
                    raise ValueError('Graph is not bipartite')
            else:
                colors[g] = neighbor_color
                set_color(g)

    for node in graph.keys():
        if colors[node] is None:
            colors[node] = 'l'
            set_color(node)
    res = {'l': [], 'r': []}
    for key, value in colors.items():
        if value == 'l':
            res['l'].append(key)
        else:
            res['r'].append(key)
    return res

def build_net(graph, colors):
    net = {key: [] for key in graph.keys()}
    net['s'] = colors['l']
    net['t'] = []
    for u in colors['r']:
        net[u].append('t')
    for u in colors['l']:
        for v in graph[u]:
            net[u].append(v)
    return net

def hungurian_assignment(a: np.ndarray):
    n, m = a.shape
    a = np.vstack([np.zeros((1, m), dtype=int), a])
    a = np.hstack([np.zeros((n+1, 1), dtype=int), a])
    u = np.zeros(n + 1, dtype=int)
    v = np.zeros(m + 1, dtype=int)
    p = np.zeros(m + 1, dtype=int)
    way = np.zeros(m + 1, dtype=int)
    for i in range(1, n + 1):
        p[0] = i
        j0 = 0
        minv = np.zeros(m + 1, dtype=int) + np.inf
        used = np.zeros(m + 1, dtype=bool)
        while True:
            used[j0] = True
            i0 = p[j0]
            delta = np.inf
            j1 = None
            for j in range(1, m+1):
                if not used[j]:
                    cur = a[i0][j] - u[i0] - v[j]
                    if cur < minv[j]:
                        minv[j] = cur
                        way[j] = j0
                    if minv[j] < delta:
                        delta = minv[j]
                        j1 = j
            for j in range(m + 1):
                if used[j]:
                    u[p[j]] += delta
                    v[j] -= delta
                else:
                    minv[j] -= delta
            j0 = j1
            if p[j0] == 0:
                break
        while True:
            j1 = way[j0]
            p[j0] = p[j1]
            j0 = j1
            if not j0:
                break
    cost = -v[0]
    ans = np.zeros(n + 1)
    for j in range(1, m+1):
        ans[p[j]] = j
    return cost, ans[1:]

# Граф для задачи о паросочетаниях
graph = {
    0: [6, 7, 11],
    1: [6, 8, 10],
    2: [7, 8, 9],
    3: [9, 10, 11],
    4: [10, 11],
    5: [6, 9],
    6: [0, 1, 5],
    7: [0, 2],
    8: [1, 2],
    9: [2, 3, 5],
    10: [1, 3, 4],
    11: [0, 3, 4]
}

max_matching = find_max_matching(graph)
print(f'Максимальное паросочетание: {max_matching}')

# Матрица затрат для задачи о назначениях
a = np.array([
    [5, 6, 1, 6, 5],
    [6, 1, 4, 4, 2],
    [3, 2, 5, 4, 3],
    [5, 6, 6, 6, 4],
    [1, 3, 2, 2, 2],
])

cost, ans = hungurian_assignment(a)
print(f'Стоимость: {cost}')
print(f'Назначения: {ans}')
