#!/bin/bash

~/scripts/isBuildFull.sh

while true; do
    read -p "Are the values < 80%?  Do you want to continue (Y/N)?" answer
    case $answer in
        [Yy]* )  break;;
        [Nn]* ) echo "OK, goodbye"; exit;;
        * ) echo "Please answer yes or no.";;
    esac
done




OPTIND=1         # Reset in case getopts has been used previously in the shell.


while getopts "h?a" opt; do
    case "$opt" in
    h|\?)
        echo '    -h or -?     for help'
        echo '    -a           sets the script to non interactive.'
        echo '                 the default is interactive'
        exit 0
        ;;
    a)
        SEMI_INTERACTIVE=0
        ;;
    esac
done

shift $((OPTIND-1))

[ "$1" = "--" ] && shift




set -e 

#
#YES I KNOW it needs to be refactored and cleaned up
#initial pass 7/25/14
#gregp
#

echo ""
echo ""

echo "What is your Gerrit username? "
read myUsername
echo ""



echo "Which branch do you wish to use ?"
branchList="develop master release ssa32-post-accept ssc-event-tracking sb-flat-fee ssc1-employer-ratings custom exit"
select ANS in $branchList;
#select ANS in develop master release custom exit
do
 case $ANS in
      develop)
        myBranch="develop"
        break
        ;;
      master)
        myBranch="master"
        break
        ;;
      release)
        myBranch="release"
        break
        ;;
      ssa32-post-accept)
        myBranch="ssa32-post-accept"
        break
        ;;
      ssc-event-tracking)
        myBranch="ssc-event-tracking"
        break
        ;;
      sb-flat-fee)
        myBranch="sb-flat-fee"
        break
        ;;     
      ssc1-employer-ratings)
        myBranch="ssc1-employer-ratings"
        break
        ;;
     custom)
        echo ""
        echo "Enter your custom branch "
        echo ""
        read ans
        myBranch=$ans
        ANS=$ans
        echo $ANS
        break
        ;;
      exit)
        break
        ;;
      *)
        echo "error invalid option"
 esac
done
echo ""
echo "You chose: "$myBranch" "



echo "Which Test Env do you wish to use ?"
envList="staging test prod custom exit"
select ANS in $envList;
#select ANS in staging test prod_web custom exit
do
 case $ANS in
      staging)
        myEnv="staging_web"
        break
        ;;
      test)
        myEnv="test"
        break
        ;;
      prod)
        myEnv="prod_web"
        break
        ;;
      custom)
        echo ""
        echo "Enter your custom branch "
        echo ""
        read ans
        myEnv=$ans
        ANS= $ans
        echo $ANS
        break
        ;;
      exit)
        break
        ;;
      *)
        echo "error invalid option"
 esac
done
echo "You chose: "$myEnv""


YEAR=`date +%Y`
MONTH=`date +%m`
DAY=`date +%d`
suggestedTag=$myBranch-$YEAR$MONTH$DAY.

echo "What is the incremental number of the tag you wish to use? "
echo ""
echo "The suggested TAG so far is: " $suggestedTag
echo ""

tagList="1 2 3 4 5 custom exit"
select ANS in $tagList;
do
 case $ANS in
      1) myTag=$suggestedTag$ANS  
         break ;;
      2) myTag=$suggestedTag$ANS  
         break ;;
      3) myTag=$suggestedTag$ANS  
         break ;;
      4) myTag=$suggestedTag$ANS  
         break ;;
      5) myTag=$suggestedTag$ANS  
         break ;;
      custom)
        echo "Enter your custom Tag  "
        read ANS
        myTag=$ANS
        echo "your Tag is: " $myTag
        ;;
      exit) break ;;
      *) echo "error invalid option"
 esac
done
echo ""
echo  "You chose: " $myTag "  " $ANS
echo ""

myHomeDir=$HOME
while true; do
    myBuilddir=$HOME"/build"
    echo "" 
    echo "      >>  " $myBuilddir
    echo ""
    read -p "Is this your build directory? (Y/N)?" answer 
    case $answer in
        [Yy]* ) cd $HOME/build;  break;;
        [Nn]* ) echo "What is your build directory? "; read newBuilddir;  myBuilddir=$newBuilddir; cd $Builddir;   break;;
        * ) echo "Please answer yes or no.";;
    esac
done

echo  "You are building as   :   " $myUsername
echo  "Using branch          :   " $myBranch
echo  "Your Tag is           :   " $myTag
echo  "Deploying to          :   " $myEnv
echo  "Your Home Dir is      :   " $myBuilddir ""
echo ""

while true; do
    read -p "Are these corrct? Do you want to continue (Y/N)?" answer
    case $answer in
        [Yy]* )  break;;
        [Nn]* ) echo "OK, goodbye"; exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
echo ""

# Initialize our own variables:
SEMI_INTERACTIVE=0

Echo "Do you want this session to be interactive or autopilot"
tagList="Interactive Autopilot exit"
select ANS in $tagList;
do
 case $ANS in
      Interactive) SEMI_INTERACTIVE=1
         break ;;
      Autopilot) SEMI_INTERACTIVE=0
         break ;;
      exit) exit ;;
      *) echo "error invalid option"
 esac
done
echo ""
echo  "You chose: " $ANS
echo ""
echo ""
echo""


doContinue () {
if  [ $SEMI_INTERACTIVE -eq 1 ]
 then
 while true; do
     read -p "Do you want to continue (Y/N)?" answer
     case $answer in
         [Yy]* )  break;;
         [Nn]* ) echo "OK, goodbye"; exit;;
         * ) echo "Please answer yes or no.";;
     esac
 done
fi
}

echo ""
echo "  ==========  CURRENT LISTING OF " $(pwd) "  ==========  "
ls -l

doContinue
echo ""
echo "  ==========  REMOVE OLD TPX  ==========  "
if [ ! -d "$DIRECTORY" ]; then
   rm -rf milton-tpx/
fi
echo ""
echo "  ==========  GET NEW TPX  ==========  "
echo "git clone ssh://"$myUsername"@buildmaster.litl.com:29418/milton-tpx"
git clone ssh://$myUsername@buildmaster.litl.com:29418/milton-tpx


doContinue
echo ""
echo "  ==========  SWITCH TO NEW BRANCH  ==========  "
echo "cd milton-tpx "
echo "git branch -r"
echo "git branch  "
echo "git checkout  " $myBranch "  
#origin/"$myBranch
echo "git branch "

cd milton-tpx/
git branch -r
git branch 
git checkout -b  $myBranch  origin/$myBranch
git branch

doContinue
echo ""
echo "  ==========  PULL BRANCH   ==========  "
echo "git pull origin "$myBranch
echo "git tag -a "$myTag

git pull origin $myBranch
git tag -a $myTag



doContinue
echo ""
echo "  ==========  PUSH TAGS  ==========  "
echo "git push --tags"
git push --tags


doContinue
echo ""
echo "  ==========  SWITCH TO OPS  ==========  "
echo "cd .."
echo "cd milton-ops/"
echo "source virtualenv/bin/activate"

cd ..
cd milton-ops/
source virtualenv/bin/activate


doContinue
echo ""
echo "  ==========  EXPORT  ==========  "
echo "export tag="$myTag
export tag=$myTag

doContinue
echo ""
echo "  ==========  BUILD RELEASE  ==========  "
echo "fab release:milton-tpx,"$tag
fab release:milton-tpx,$tag


doContinue
echo ""
echo "  ==========  DEPLOY RELEASE TO " $myEnv "  ==========  "
echo "fab -R " $myEnv " deploy:milton-tpx,"$tag
fab -R $myEnv deploy:milton-tpx,$tag,force=true #|tee afile
echo ""
echo "Checking for errors?"
#cat afile |grep -i 'error'
echo "If you do not see errors, you are all set"

echo ""
echo "."
echo "."
echo "."
echo ""

echo "you still need to roll forward as you wish ..."
echo ""
echo " cd into milton-ops "
echo " activate with:  'source virtualenv/bin/activate' "

 case $myEnv in
      staging) targetEnv='staging_web'
         break ;;
      prod) targetEnv='prod_web'
         break ;;
      test) targetEnv=$myEnv
         break ;;
      demo) targetEnv=$myEnv
         break ;;
      dev) targetEnv=$myEnv
         break ;;
      *) echo $myEnv " : error invalid option"
 esac

echo " then run :    fab -R " $targetEnv " rollforward:milton-tpx    "
echo ""
echo "and up the wiki with this latest build info " $tag
echo "(https://goscoutgo.atlassian.net/wiki/pages/viewpage.action?pageId=8487049)"
echo ""  
git show --quiet refs/tags/458-pending-state-20141209.1>gitlog &&
cat gitlog


