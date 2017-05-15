#!/bin/bash
echo "---------------------------------"
echo "Act.Framework Project Starter Kit"
echo "---------------------------------"
echo ""
echo "(C)2017 Thinking.Studio "
echo "Written by J.Cincotta"
echo ""
echo "use -? for help."
echo ""

#Set script dirs
BASEDIR=`dirname $0`
if [[ "${BASEDIR}" == '.' ]];
    then
        BASEDIR=`pwd`
fi
RSRCDIR=${BASEDIR}/rsrc

for i in "$@"
do
case $i in
    -n=*|--name=*)
    PROJECTNAME="${i#*=}"
    shift # past argument=value
    ;;
    -o=*|--org=*)
    ORGNAME="${i#*=}"
    shift # past argument=value
    ;;
    -p=*|--path=*)
    PROJECTPATH="${i#*=}"
    shift # past argument=value
    ;;
    -v=*|--version=*)
    MYACTVERSION="${i#*=}"
    shift # past argument=value
    ;;
    --node)
    NODE=YES
    shift # past argument with no value
    ;;
    --rythm)
    RYTHM=YES
    shift # past argument with no value
    ;;

    -?|--help)
        echo ""
        echo "This little script will create everything you need to get an Act.Framework project set up so you can start writing code. The idea is that there are some basic conventions we agree to use with the structure of projects when using Act.Framework - and this script sets all that up for you without you needing to know everything beforehand."
        echo ""
        echo "The Node.JS support is designed to allow Act.Framework to be used for modern web development easily. All you need to do is turn on Node.JS support when you set up a project and the script will set up everything you need to start making a web application with a full Javascript build pipeline as well as Act - all in one. We started using this convention when we developed the Act.Framework website and it worked so well, we have made it a defacto standard."
        echo ""
        echo ""
        echo "act-new.sh [--node --rythm] [-v=<act version>]  -p=<full-project-path> -n=<project name> -o=<organisation/package name>"
        echo ""
        echo "--version=<act version>"
        echo "This is an optional field. It will set the version being called from Maven. If you leave it blank, the script will query Maven to get the latest version and use that."
        echo ""
        echo "--node"
        echo "Insert node.js compatibility and build pipeline"
        echo ""
        echo "--rythm"
        echo "Insert Rythm template directory structure"
        echo ""
        echo "-? or --help ... well, you know what that command does now. You're reading this..."
        echo ""
        echo ""
        echo "EXAMPLE:"
        echo "act-new.sh --node --rythm -p=~/development/hello-world -n=hello-world -o=com.mycompany.examples"
        echo ""
        exit
    shift # past argument=value
    ;;
    *)
            # unknown option
    ;;
esac
done

#verify we have parameters to work with...chances are user has no idea if these are blank. Let them use -? without blowing anything up.
if [[ "${PROJECTPATH}" == '' ]] || [[ "${PROJECTNAME}" == '' ]] || [[ "${ORGNAME}" == '' ]];
    then
        exit
fi


echo -n "Working"

#create project dir
echo -n "."
mkdir ${PROJECTPATH}
cd ${PROJECTPATH}

#create java src structure and populate
echo -n "."
mkdir src
cd ${PROJECTPATH}/src/

#standard assembly 
echo -n "."
mkdir assembly
cd assembly 
cp ${RSRCDIR}/assembly/* ./

#main dir structure
echo -n "."
cd ${PROJECTPATH}/src/
mkdir main

#standard binary launchers for win and unix 
echo -n "."
cd ${PROJECTPATH}/src/main/
mkdir bin
cd bin
cp ${RSRCDIR}/bin/run ./
chmod u+x ./run
cp ${RSRCDIR}/bin/start ./
chmod u+x ./start
cp ${RSRCDIR}/bin/run.bat ./
cp ${RSRCDIR}/bin/start.bat ./

#create resources dir structure
echo -n "."
cd ${PROJECTPATH}/src/main/
mkdir resources
cd resources

#create static asset directories for Rythm templates to refer to
echo -n "."
cd ${PROJECTPATH}/src/main/resources/
mkdir asset
cd asset
mkdir css
mkdir js
mkdir img

#create configuration structure and a placeholder properties file you can populate
echo -n "."
cd ${PROJECTPATH}/src/main/resources/
mkdir conf
cd conf
mkdir common
cd common
touch app.properties

#create resources files in top level dir structure
echo -n "."
cd ${PROJECTPATH}/src/main/resources/
cp ${RSRCDIR}/resources/app.version ./
cp ${RSRCDIR}/resources/logback.xml ./
touch routes.conf
touch messages.properties
touch messages_en.properties
touch messages_zh_CN.properties

#create Java path and initial controller
echo -n "."
cd ${PROJECTPATH}/src/main/
mkdir java
cd java
IFS='.' read -r -a array <<< "$ORGNAME"
for element in "${array[@]}"
do
    mkdir "$element"
    cd "$element"
done
mkdir ${PROJECTNAME}
cd ${PROJECTNAME}
sed -e "s/ProjectName/${PROJECTNAME}/" -e "s/PackageName/${ORGNAME}/" ${RSRCDIR}/java/App.java >./App.java

if [[ "${RYTHM}" == 'YES' ]];
    then
        #create the Rythm structure
        echo -n "."
        cd ${PROJECTPATH}/src/main/resources/
        mkdir rythm
        cd rythm
        IFS='.' read -r -a array <<< "$ORGNAME"
        for element in "${array[@]}"
        do
            mkdir "$element"
            cd "$element"
        done
        mkdir ${PROJECTNAME}
        cd ${PROJECTNAME}
        #create the Rythm base template
        echo -n "."
        mkdir App
        cd App
        sed "s/ProjectName/${PROJECTNAME}/" ${RSRCDIR}/rythm/home.html >./home.html
        #create global import for Rythm
        cd ${PROJECTPATH}/src/main/resources/rythm/
        sed -e "s/ProjectName/${PROJECTNAME}/" -e "s/PackageName/${ORGNAME}/" ${RSRCDIR}/rythm/__global.rythm >./__global.rythm
fi

if [[ "${NODE}" == 'YES' ]];
    then
        #Setup Node.JS support
        echo -n "."
        cd ${PROJECTPATH}/
        mkdir css.src
        mkdir js.src
        mkdir less.src
        cp ${RSRCDIR}/node/gulpfile.js ./
        sed "s/ProjectName/${PROJECTNAME}/" ${RSRCDIR}/node/package.json >./package.json
fi

#Setup Act.Framework project commands
echo -n "."
cd ${PROJECTPATH}/
cp ${RSRCDIR}/root/run_dev ./
chmod u+x ./run_dev
cp ${RSRCDIR}/root/run_prod ./
chmod u+x ./run_prod
cp ${RSRCDIR}/root/setup_project ./
chmod u+x ./setup_project

echo -n "."
curl https://repo.maven.apache.org/maven2/org/actframework/act/maven-metadata.xml >act_version.tmp
ACTVERSION=$(awk -F '[<>]' '/latest/{print $3}' act_version.tmp)
sed -e "s/ProjectName/${PROJECTNAME}/" -e "s/PackageName/${ORGNAME}/" -e "s/ActVersion/${ACTVERSION}/" ${RSRCDIR}/root/pom.xml >./pom.xml
rm act_version.tmp


echo "OK"


