# ! /bin/bash
#set -x

#
# Trying to make my life slightly better! :)
# Inspired from https://github.com/charlesthomas/todo.md
#

#
# key words
KEYS="TODO FIXME HACK XXX BUG"

#
# global constants
GIT_ROOT=$(git rev-parse --show-toplevel)
TODO_FILE="${GIT_ROOT}/TODO.md"

if [ ${GIT_ROOT} != $(pwd) ];
then
	echo "Execute this on the top-most folder!"
	exit 1
fi

_keys=""
for _key in ${KEYS}
do
	_keys=$(echo "${_keys} -e ${_key}")
done

> /tmp/.todo.md
git grep -Iinw $_keys ${GIT_ROOT} | grep -v "^\." | grep -vi 'TODO\.md' | grep -vi ${0} | grep -vi 'README\.md' > /tmp/.todo.md

exec 1>${TODO_FILE}

echo "TODO"
echo "===="
echo


_current_file=''
while IFS= read -r line
do
	_fname=$(echo ${line} | cut -f1 -d':')
	_lnum=$(echo ${line} | cut -f2 -d':')
	_text=$(echo ${line} | cut -f3- -d':')

	if [[ ${_fname} != ${_current_file} ]]
	then
		if [ ${_current_file} ]
		then
			echo
		fi
		_current_file=${_fname}
		echo "## ${_current_file}"
		echo "Line|Content"
		echo "---|---"
	fi

	echo "**${_lnum}** | ${_text}"
done < /tmp/.todo.md
echo "---"
echo "* Generated automatically by [TODO.md_gen.sh](https://github.com/meetrp/generic/blob/master/todo.md.sh)*"
echo

$(git add ${TODO_FILE})
