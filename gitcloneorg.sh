#!/bin/bash
. $(basename $0).rc

#requires curl + jq
#echo $ORG
#echo $GIT_TOKEN

export GIT_ASKPASS=$(dirname $(realpath $0))/git_ask_pass.sh

quiet_git() {
    stdout=$(tempfile)
    stderr=$(tempfile)

    if ! GIT_TOKEN=$GIT_TOKEN git "$@" </dev/null >$stdout 2>$stderr; then
        cat $stderr >&2
        rm -f $stdout $stderr
        exit 1
    fi

    rm -f $stdout $stderr
}


cd $(dirname $0)/$ORG

for REPO_URL in `curl -u $GIT_TOKEN:x-oauth-basic -s "https://api.github.com/orgs/$ORG/repos?per_page=10000" | jq -r .[].clone_url`; do
	REPO_DIR=${REPO_URL##*/}
	REPO_DIR=${REPO_DIR%.git}
	#echo $REPO_URL $REPO_DIR
	if [ -d "$REPO_DIR" ]; then
		[ -t 1 ] && echo pulling $REPO_URL in $REPO_DIR
		cd $REPO_DIR
		quiet_git pull 
		cd ../
	else 
		[ -t 1 ] && echo cloning  "$REPO_URL"
		quiet_git clone "$REPO_URL" 
	fi
done
