#!/bin/bash
# LMU Munich. AG Enard
# splitting fastq files to filter using multiple processors.
# Authors: Swati Parekh, Christoph Ziegenhain, Beate Vieth & Ines Hellmann
# Contact: sparekh@age.mpg.de or christoph.ziegenhain@ki.se

function splitfq() {
	fqfile=$1
  pexc=$2
  nthreads=$3
  nreads==`expr $4 / 4`
  t=$5
	project=$6

  n=`expr $nreads / $nthreads`
	n=`expr $n + 1`
	nl=`expr $n \* 4`
  pref=`basename $fqfile`
  d=`dirname $fqfile`
  split --lines=$nl --filter=''$pexc' -p '$nthreads' > $FILE.gz' $d/$fqfile $t$pref

	ls $t$pref* | sed "s|$t$pref||" > $t/$project.listPrefix.txt

	exit 1
}
function splitfqgz() {
	fqfile=$1
  pexc=$2
  nthreads=$3
  nreads=`expr $4 / 4`
  t=$5
	project=$6

  n=`expr $nreads / $nthreads`
  n=`expr $n + 1`
  nl=`expr $n \* 4`
  pref=`basename $fqfile .gz`
  d=`dirname $fqfile`
  $pexc -dc -p $nthreads $d/$pref.gz | split --lines=$nl --filter=''$pexc' -p '$nthreads' > $FILE.gz' - $t$pref

	ls $t$pref* | sed "s|$t$pref||" | sed 's/.gz//' > $t/$project.listPrefix.txt

	exit 1
}

i=$1
pigzexc=$2
num_threads=$3
tmpMerge=$4
fun=$5
project=$6
f=$7


if [[ $f =~ \.gz$ ]]; then
	nlines=`$pigzexc -p $num_threads -d -c $f | wc -l`
else
	nlines=`wc -l $f | awk '{print $1}'`
fi

$fun "$i" "$pigzexc" "$num_threads" "$nlines" "$tmpMerge" "$project"
