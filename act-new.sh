#!/bin/bash
echo 
echo "---------------------------------"
echo "Act.Framework Project Starter Kit"
echo "---------------------------------"
echo ""
echo "(C)2017 Thinking.Studio "
echo "Written by J.Cincotta"
echo ""
echo "Use -? for help with command-line usage. Use this script without options for interactive (wizard) mode."
echo ""

#Set script dirs
BASEDIR=`eval echo "$(dirname "$(readlink "$0")")"`
if [[ "${BASEDIR}" == '.' ]]; then
    BASEDIR="$(cd "$(dirname "$0")" && pwd)"
fi
RSRCDIR=`eval echo "${BASEDIR}/rsrc"`
MYACTVERSION=""
NODE=NO
RYTHM=NO

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
        echo "This wizard will create everything you need to get an Act.Framework project set up so you can start writing code. The idea is that there are some basic conventions we agree to use with the structure of projects when using Act.Framework - and this script sets all that up for you without you needing to know everything beforehand."
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
#or go into interactive mode!
if [[ "${PROJECTPATH}" == '' ]] || [[ "${PROJECTNAME}" == '' ]] ;
    then
    echo "Act.Framework Interactive Project Setup..."
    echo 
    echo -n "Enter the directory for the new project: "
    read PROJECTPATH
    echo
    echo -n "Enter the name of this project (lower case name): "
    read PROJECTNAME
    echo
    echo -n "Enter the organisation package name (Java style like com.google.utilities): "
    read ORGNAME
    echo
    echo -n "Would you like to use the Rythm templating engine with this project? [y/n]: "
    read -n 1 userythm
    echo 
    echo -n "Would you like to use Node.JS and Gulp with this project? [y/n]: "
    read -n 1 usenode
    if [[ "${usenode}" == 'y' ]] ; then
        NODE=YES
    fi
    if [[ "${userythm}" == 'y' ]] ; then
        RYTHM=YES
    fi
fi

echo
echo
echo -n "Working"

#Fix project path (expand ~ if there is one... and deal with relative path)
tempProjectPath=${PROJECTPATH}
if [[ ${tempProjectPath:0:1} == "~" ]] || [[ ${tempProjectPath:0:1} == "/" ]]; then 
    PROJECTPATH=`eval echo "${tempProjectPath}"`
else
    PROJECTPATH="$(pwd)"/"${PROJECTPATH}"
fi


#fix package name and project name convergance, remove situations where the project name is also on the end of the package name
if [[ "${ORGNAME}" != "" ]]; then
    tmpoutput=""
    IFS='.' read -r -a array <<< "$ORGNAME"
    arraysize=${#array[@]}
    lastindex=$(expr $arraysize - 1)
    if [[ "${array[$lastindex]}" == "$PROJECTNAME" ]]; then
        for (( i=0; i<${lastindex}; i++ ));
        do
            if [[ $i == 0 ]]; then
                tmpoutput="${array[$i]}"
            else
                tmpoutput="${tmpoutput}.${array[$i]}"
            fi
        done
        ORGNAME=${tmpoutput}
    fi
fi

if [[ "${ORGNAME}" == "" ]]; then
    PACKAGENAME="${PROJECTNAME}"
else
    PACKAGENAME="${ORGNAME}.${PROJECTNAME}"
fi


#create project dir
echo -n "."
mkdir ${PROJECTPATH}
cd ${PROJECTPATH}

#create java src structure and populate
echo -n "."
mkdir src
cd ${PROJECTPATH}/src/

#main dir structure
echo -n "."
cd ${PROJECTPATH}/src/
mkdir main

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
echo "i18n=true" >app.properties
echo "#common db configuration" >db.properties
echo "" >>db.properties
echo "## uncomment for mongodb project" >>db.properties
echo "#db.impl=act.db.morphia.MorphiaPlugin" >>db.properties
echo "#db.uri=mongodb://localhost/mydb?maxPoolSize=256" >>db.properties
echo "" >>db.properties
echo "## uncomment for sql project" >>db.properties
echo "#db.impl=act.db.ebean2.EbeanPlugin" >>db.properties
echo "#db.url=jdbc:mysql://localhost:3306/mydb" >>db.properties
echo "#db.username=<username>" >>db.properties
echo "#db.password=<password>" >>db.properties

_PROFILE='prod'
cd ${PROJECTPATH}/src/main/resources/conf/
mkdir $_PROFILE
cd $_PROFILE
echo "#general $_PROFILE configuration" >app.properties

echo "#$_PROFILE db configuration" >db.properties
echo "" >>db.properties
echo "## uncomment for mongodb project" >>db.properties
echo "#db.impl=act.db.morphia.MorphiaPlugin" >>db.properties
echo "#db.uri=mongodb://localhost/mydb?maxPoolSize=256" >>db.properties
echo "" >>db.properties
echo "## uncomment for sql project" >>db.properties
echo "#db.impl=act.db.ebean2.EbeanPlugin" >>db.properties
echo "#db.url=jdbc:mysql://localhost:3306/mydb" >>db.properties
echo "#db.username=<username>" >>db.properties
echo "#db.password=<password>" >>db.properties

echo "#$_PROFILE mail configuration" >mail.properties
echo "#mailer.from=support@mycompany.com" >>mail.properties
echo "" >>mail.properties
echo "#mailer.smtp.username=<your-smtp-service-user-name>" >>mail.properties
echo "#mailer.smtp.password=<your-smtp-service-password>" >>mail.properties
echo "#mailer.smtp.host=<your-smtp-service-host>" >>mail.properties
echo "#mailer.smtp.port=587" >>mail.properties
echo "#mailer.smtp.tls=true" >>mail.properties
echo "#mailer.smtp.ssl=false" >>mail.properties

_PROFILE='uat'
cd ${PROJECTPATH}/src/main/resources/conf/
mkdir $_PROFILE
cd $_PROFILE
echo "#general $_PROFILE configuration" >app.properties

echo "#$_PROFILE db configuration" >db.properties
echo "" >>db.properties
echo "## uncomment for mongodb project" >>db.properties
echo "#db.impl=act.db.morphia.MorphiaPlugin" >>db.properties
echo "#db.uri=mongodb://localhost/mydb?maxPoolSize=256" >>db.properties
echo "" >>db.properties
echo "## uncomment for sql project" >>db.properties
echo "#db.impl=act.db.ebean2.EbeanPlugin" >>db.properties
echo "#db.url=jdbc:mysql://localhost:3306/mydb" >>db.properties
echo "#db.username=<username>" >>db.properties
echo "#db.password=<password>" >>db.properties

echo "#$_PROFILE mail configuration" >mail.properties
echo "#mailer.from=support@mycompany.com" >>mail.properties
echo "" >>mail.properties
echo "#mailer.smtp.username=<your-smtp-service-user-name>" >>mail.properties
echo "#mailer.smtp.password=<your-smtp-service-password>" >>mail.properties
echo "#mailer.smtp.host=<your-smtp-service-host>" >>mail.properties
echo "#mailer.smtp.port=587" >>mail.properties
echo "#mailer.smtp.tls=true" >>mail.properties
echo "#mailer.smtp.ssl=false" >>mail.properties

#create resources files in top level dir structure
echo -n "."
cd ${PROJECTPATH}/src/main/resources/
touch routes.conf
touch messages.properties
touch messages_en.properties
touch messages_zh_CN.properties

#create .version file
echo -n "."
cd ${PROJECTPATH}/src/main/resources/
IFS='.' read -r -a array <<< "$ORGNAME"
for element in "${array[@]}"
do
    mkdir "$element"
    cd "$element"
done
cp ${RSRCDIR}/resources/.version ./

#create logback.xml file
echo -n "."
cd ${PROJECTPATH}/src/main/resources/
sed -e "s/PackageName/${PACKAGENAME}/" ${RSRCDIR}/resources/logback.xml >./logback.xml


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
sed -e "s/ProjectName/${PROJECTNAME}/" -e "s/PackageName/${PACKAGENAME}/" ${RSRCDIR}/java/AppEntry.java >./AppEntry.java

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
        mkdir AppEntry
        cd AppEntry
        sed "s/ProjectName/${PROJECTNAME}/" ${RSRCDIR}/rythm/home.html >./home.html
        #create global import for Rythm
        cd ${PROJECTPATH}/src/main/resources/rythm/
        sed -e "s/PackageName/${PACKAGENAME}/" ${RSRCDIR}/rythm/__global.rythm >./__global.rythm
fi

if [[ "${NODE}" == 'YES' ]]; then
        #Setup Node.JS support
        echo -n "."
        cd ${PROJECTPATH}/
        mkdir css.src
        mkdir js.src
        mkdir less.src
        cp ${RSRCDIR}/node/gulpfile.js ./
        sed "s/ProjectName/${PROJECTNAME}/" ${RSRCDIR}/node/package.json >./package.json
fi

#Setup Act.Framework project commands (based on project configuration)
echo -n "."
cd ${PROJECTPATH}/
if [[ "${NODE}" == 'YES' ]]; then
    cp ${RSRCDIR}/root/run_node_dev ./run_dev
    chmod u+x ./run_dev
    cp ${RSRCDIR}/root/run_node_prod ./run_prod
    chmod u+x ./run_prod
    cp ${RSRCDIR}/root/setup_project ./
    chmod u+x ./setup_project
else
    cp ${RSRCDIR}/root/run_dev ./
    chmod u+x ./run_dev
    cp ${RSRCDIR}/root/run_prod ./
    chmod u+x ./run_prod
fi

echo -n "."
if [[ "${MYACTVERSION}" == '' ]]; then
    echo -n "."
    curl -sS https://repo.maven.apache.org/maven2/org/actframework/act-starter-parent/maven-metadata.xml >act_version.tmp
    #ACTVERSION=$(awk -F '[<>]' '/latest/{print $3}' act_version.tmp)
    ACTVERSION=1.6.0.3 #TODO the hardcode is a special case, it will be turned off once act-starter-parent released 1.6.1.1 version
    rm act_version.tmp
else
    ACTVERSION=${MYACTVERSION}
fi

echo -n "."
sed -e "s/ProjectName/${PROJECTNAME}/" -e "s/PackageName/${PACKAGENAME}/" -e "s/ActVersion/${ACTVERSION}/" ${RSRCDIR}/root/pom.xml >./pom.xml

echo
echo "-------------------"
echo "New Project Summary"
echo "-------------------"
echo "Project location: ${PROJECTPATH}"
echo "Package name: ${ORGNAME}.${PROJECTNAME}"
echo "Configured to use Act.Framework version ${ACTVERSION}"
echo "Node.JS and Gulp support: ${NODE}"
echo "Rythm Template Engine suport: ${RYTHM}"
echo

