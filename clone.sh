#! /bin/bash
echo 'Starting clone.sh'
echo 'Reading settings.gradle file'
gitHubAccount="RideScout"
reposArray=()
while read p|| [[ -n $p ]]; do
	if [[ $p == *"include"* ]]
	then
  		IFS="'" read -ra ADDR <<< "$p"
		for i in "${ADDR[@]}"; do
			if [[ $i != *"app"* && $i != *"include"*  && $i != *","* ]]
			then
    			IFS=":" read -ra ADDR2 <<< "$i"
				for j in "${ADDR2[@]}"; do
					size=${#j}
					if [[ $j != *"libraries"* && $size -ge 1 ]]
					then
						reposArray+=($j)
					fi
				done
    		fi
		done
	fi
done < settings.gradle
echo "repos to clone: ${reposArray[@]}"

for repo in "${reposArray[@]}"; do
	gitHubAddress="https://github.com/$gitHubAccount/$repo.git"
	if [ ! -d "../$repo" ]; then
		echo "cloning $repo. Generated address: $gitHubAddress"
		git clone $gitHubAddress
		mv $repo ..
	else
		echo "skiped $repo as it already exists"
	fi
done

exit 0

