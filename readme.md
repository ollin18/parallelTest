
# mpitest repo

In this repository I collect a couple of mpi-related tests. All tests are performed in the R language. 
I use R and MPI with [R package snow](http://cran.r-project.org/web/packages/snow/index.html).

## clusterTime

In this test I run a standard computational task on a given number of compute nodes, for several 
times. The computation is aimed to be both memory and CPU intensive. I compute the Fibonacci sequence
of order 30 for 10 times on each node. The function is defined by `F(0) = 0, F(1) = 1, F(n) = F(n-1) + F(n-2)`. In R:

```r
fibR <- function(n) {
    if (n == 0) return(0)
    if (n == 1) return(1)
    return (fibR(n - 1) + fibR(n - 2))
}
```

This implementation is deliberately inefficient.

### Setup

Every compute performs the exact identical operations.

### Result

I conduct the experiment twice. In both runs, there exist compute nodes which perform much worse than others. I am trying to understand the reasons behind this. 
I can almust exclude "congestion on the node", since the SGE scheduler assigns all nodes to my job (4 or 12 respectively). It is hard to say if the problem is 
compute-node specific, since in every experiment I get a different subset of nodes.


## singleThread

standard SGE tests.

## Multicore

Trial for hybrid MPI + OpenMP programming. Fails in the standard setup, since requires a special *thread-safe* version of MPI. google "hybrid programming" for more.