### The initial set of commands to implement. They cover a broad
### selection of Stata features and will help test the infrastructure
### other commands will eventually rely on.

## Self-explanatory
exit <-
function(...)
{
    cond <- simpleCondition("Exit requested")
    class(cond) <- c(class(cond), "exit")

    signalCondition(cond)
}

quit <- exit

## Data manipulation commands
generate <-
function(...)
{

}

insheet <-
function(...)
{

}

## Immediate commands
display <-
function(...)
{

}

## Stats commands
logit <-
function(...)
{

}

tab <-
function(...)
{

}

## Graphics commands
scatter <-
function(...)
{

}

bar <-
function(...)
{

}

## Macro management commands
local <-
function(...)
{

}

global <-
function(...)
{

}

