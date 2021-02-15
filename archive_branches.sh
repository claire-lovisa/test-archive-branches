#!/bin/bash

# Credits to https://gist.github.com/augustogiles/528176e0eac6b066195ff25e10f52849 :)

current_branch=$(git rev-parse --abbrev-ref HEAD)
target_branch=$1
if [ -z "$target_branch" ] 
then
	target_branch=$current_branch
fi

response="DECIDE"
while ! [[ $response =~ ^([yY])$ ]];
do
    read -p "Do you want to run this script based in branch $target_branch? [Y|N] " response   
    echo
    if [[ $response =~ ^([yY])$ ]]
    then
        echo "Ok, proceeding"
    elif [[ $response =~ ^([nN])$ ]]
    then
    	echo "No, terminating"
        exit 0
    fi
done


branches=$(git branch -r --merged | grep -v HEAD | grep -v master | grep -v development)
branch_amount=$(echo "$branches" | sed '/^[[:space:]]*$/d' | wc -l) # trim empty lines before counting

echo "$branch_amount branches to examinate:"
echo "$branches"

if [[ $branch_amount != 0 ]]
then
	while read branch; do
		BRANCH=$(echo $branch | sed 's/origin\///')
		response_branch="DECIDE"
		while ! [[ $response_branch =~ ^([yY])$|^([nN])$ ]];
		do
			read -p "Do you want to archive branch $BRANCH ? [Y|N] " response_branch </dev/tty
			if [[ $response_branch =~ ^([yY])$ ]]
			then
				echo "Ok, proceeding"
				echo "======= Checking out to $BRANCH ======="

				git checkout -b $BRANCH

				echo "======= pulling branch ======="

				git pull origin $BRANCH

				echo "======= Tagging branch to archive ======="

				git tag archive/$BRANCH $BRANCH

				echo "======= Removing branch $BRANCH ======="

				git checkout $target_branch
				git branch -d $BRANCH
				git push origin :$BRANCH
			elif [[ $response_branch =~ ^([nN])$ ]]
				then
					echo "Skipping branch $BRANCH ..."
				fi
		done
	done <<< "$branches"

	echo "======= Pushing tags ======="
	git push --tags

fi

echo "END OF SCRIPT"
