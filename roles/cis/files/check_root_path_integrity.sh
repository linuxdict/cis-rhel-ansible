#!/bin/bash
cat /etc/passwd | awk -F: '{ print $1 " " $3 " " $6 }' | while read user uid dir; do
  if [ $uid -ge 500 -a ! -d "$dir" -a $user != "nfsnobody" ]; then
    echo "The home directory ($dir) of user $user does not exist."
  fi
done
[root@ip-10-1-1-195 files]# cat ./check_root_path_integrity.sh
#!/bin/bash
if [ "`echo $PATH | grep :: `" != "" ]; then
    echo "Empty Directory in PATH (::)"
fi
if [ "`echo $PATH | grep :$`"  != "" ]; then
  echo "Trailing : in PATH"
fi
p=`echo $PATH | sed -e 's/::/:/' -e 's/:$//' -e 's/:/ /g'`
set -- $p
while [ "$1" != "" ]; do
  if [ "$1" = "." ]; then
    echo "PATH contains ."
    shift
    continue
  fi
  if [ -d $1 ]; then
    dirperm=`ls -ldH $1 | cut -f1 -d" "`
    if [ `echo $dirperm | cut -c6 ` != "-" ]; then
      echo "Group Write permission set on directory $1"
    fi
    if [ `echo $dirperm | cut -c9 ` != "-" ]; then
      echo "Other Write permission set on directory $1"
    fi
    dirown=`ls -ldH $1 | awk '{print $3}'`
    if [ "$dirown" != "root" ] ; then
      echo $1 is not owned by root
    fi
  else
    echo $1 is not a directory
  fi
  shift
done
