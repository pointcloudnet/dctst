infile=$1
target=$2
suffix=$(date -Ins)
sed -i${suffix} "/^__bash_prompt()/r $infile
/^__bash_prompt()/,/^__bash_prompt$/d" $target
