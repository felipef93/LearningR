#This file contains functions corresponding to exercises of 
# Week 3 in the R programming online course by Johns Hopkins University 

#The function makevector creates 2 store variables: x(vector) and m(numeric) controlled by 4 functions (set, get,setmean, getmean)
makeVector <- function(x = numeric()) { #Variable x initialized
  m <- NULL #variable m initialized
  set <- function(y) {
    x <<- y
    m <<- NULL # note that whenever set is called m will assume the value of NULL
    # This is possible because of <<- which allows to define a variable that is not in the "set" environment
               
  }
  get <- function() x
  setmean <- function(meanvec) m <<- meanvec #after assuming NULL value above m is defined as being eq
  # to meanvec
  getmean <- function() m
  list(set = set, get = get,
       setmean = setmean,
       getmean = getmean)
}

#The second function defines what should be stored in the previously defined variables

cachemean <- function(x, ...) {
  m <- x$getmean() #verifies if there is a value stored in m
  if(!is.null(m)) { # if there is it will not perform calculations again
    message("getting cached data")
    return(m) #just return the previous value
  }
  data <- x$get() # if not it will get the value stored in x in makevector function
  m <- mean(data, ...) #calculate the mean
  x$setmean(m) #then set the mean
  m
}

a1<-c(runif(9))
b1<-makeVector(a1)
## Put comments here that give an overall description of what your
## functions do

#The function makevector creates 2 store matrixes (x and m) controlled by 4 functions (set, get,setinverse, getinverse)

makeCacheMatrix <- function(x = matrix()) { #x is initialized
    m <- matrix(NA,nrow=nrow(x),ncol=ncol(x)) #m is initialized
    set <- function(y) { 
      x <<- y #set gets the value of x
      m <<-  matrix(NA,nrow(x),ncol(x)) #again if set is called m will be "reset" to a matrix of NAs
    }
    get <- function() x
    setinverse <- function(inversematrix) m <<-inversematrix #Variable m is set again according to function set inverse
    getinverse <- function() m
    list(set = set, get = get,
         setinverse = setinverse,
         getinverse = getinverse)
  }
  
#The second function defines what should be stored in the previously defined variables

cacheSolve <- function(x, ...) {
  m <- x$getinverse() #verifies if there is a value stored in m
  if(!(all(is.na(m)))) {
    message("getting cached data")
    return(m) # if there is return this values
  }
  data <- x$get() #else it will take the matrix stored in x
  m <- solve(data) #calculate the inverse of the matrix
  x$setinverse(m) #set the variable m to being the inverse of the matrix
  m
}

a2<-matrix(runif(9),3,3)
b2<-makeCacheMatrix(a2)