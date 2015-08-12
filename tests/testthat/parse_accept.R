context("Parser accepts all and only valid input")

#Special commands
merge 1:m id using "final.dta"
merge 1:1 id using "final.dta"
merge m:1 id using "final.dta"
merge m:m id using "final.dta"
merge m:1 id firstname lastname using "final.dta"
merge m:m id lastname using "final.dta", gen(foo)

xi var1
xi var1 var2
xi var1 var2, opt
xi var1 var2, opt opt2(param)

ivregress y x1 x2 x3 (contact = treat)
ivregress y x1 x2 x3 (contact = treat) if treat != 4, cluster(household)

gsort +hhid -phone_score
gsort +hhid -phone_score, mfirst

collapse support voteprop
collapse (mean) support voteprop (first) state, by(track)
collapse (mean) support voteprop (first) state id=id, by(track)

lrtest A (B C)
lrtest . (B C)
lrtest A (B .)

anova y i.x
anova y i.x#z
anova y i.x##c.z
anova y i.x|c.z
anova y i.x|c.z /
anova y i.x|c.z /, option(val)

recode treat (2 3 = 1)
recode treat1 treat2 (2 3 = 1) (4 5 = 9)
recode treat1 treat2 (2 3 = 1) (4/5 = 9)
recode treat1 treat2 (2 . = 1) (4/5 = 9)
recode treat1 treat2 (2 . = 1) (4/5 = 9)
recode treat1 treat2 (missing = 1) (4/5 = 9)
recode treat1 treat2 (missing = 1) (4/5 = 9), gen(newvar)

#Prefix commands
quietly gen foobar = 1
qui gen foobar = 1

capture
noisily
by
bysort
xi

#Macro commands
local
local
global
tempfile
macro

#Deeply nested expressions should work

#General commands
append
clear
codebook
compare
count
decode
describe
destring
dir
drop
duplicates
egen
encode
erase
expand
flist
format
generate
insheet
isid
keep
label
list
lookfor
ls
mkdir
order
recast
rename
reshape
rm
rmdir
sample
save
separate
sort
split
tostring
type
use
xtile
about
cd
creturn
di
display
do
exit
help
if
log
preserve
pwd
query
quit
restore
run
set
sleep
sysuse
ameans
areg
binreg
bitest
ci
correlate
estimates
fvset
glm
gnbreg
icc
ivregress
ksmirnov
kwallis
logistic
logit
lrtest
margins
mean
nbreg
ologit
pctile
poisson
predict
probit
prtest
pwcorr
ranksum
regress
sktest
summarize
tab
tab1
tab2
table
tabstat
tabulate
test
ttest

