# Enable math functions e.g. (( f = sin(0.3) ))
zmodload zsh/mathfunc

alias math-sum=$'awk \'{ sum += $1 } END { print sum }\''

alias math-avg=$'awk \'{ sum += $1; count+=1 } END { print sum / count }\''

alias math-min=$'awk \'!init { init = 1; min = $1 } { min = ($1 < min ? $1 : min) } END { print min }\''

alias math-max=$'awk \'!init { init = 1; max = $1 } { max = ($1 > max ? $1 : max) } END { print max }\''

alias math-analyse=$'awk \'
!init { init = 1;
  min = $1 
  max = $1
}
{ 
  cnt +=1;
  sum += $1; 
  min = ($1 < min ? $1 : min);
  max = ($1 < max ? $1 : max);
} END { 
  print "cnt: " cnt; 
  print "sum: " sum; 
  print "min: " min; 
  print "max: " max; 
  print "avg: " (cnt ? sum / cnt : null); 
}\''