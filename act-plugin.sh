#!/bin/bash

echo "---------------------------------"
echo "Act.Framework Plugin Manager     "
echo "---------------------------------"
echo ""
echo "(C)2017 Thinking.Studio "
echo "Written by J.Cincotta"
echo ""
echo "Use -? for help with command-line usage."
echo ""
echo "Use --list to list all official plugins in the Act.Framework Maven repository." 
echo ""

#Set script dirs
BASEDIR=`eval echo "$(dirname "$(readlink "$0")")"`
if [[ "${BASEDIR}" == '.' ]]; then
    BASEDIR="$(cd "$(dirname "$0")" && pwd)"
fi
RSRCDIR=`eval echo "${BASEDIR}/rsrc"`


for i in "$@" 
do 
case $i in
    -p=*|--path=*)
    PROJECTPATH="${i#*=}"
    shift # past argument=value
    ;;
    -i=*|--plugin=*)
    PLUGIN="${i#*=}"
    shift # past argument=value
    ;;
    --list)
    LIST="YES"
    shift # past argument with no value
    ;;
    -?|--help)
        echo ""
        echo "act-plugin.sh -p=<full-project-path> -i=<plugin name>"
        echo ""
        echo "--path=<path name>"
        echo "The path to the root of the Act.Framework project."
        echo ""
        echo "--plugin=<plugin name>"
        echo "You can find the names of the plugins from the GitHub website here https://github.com/actframework ."
        echo ""
        echo "--list"
        echo "This will list all available plugins available in the Act.Framework Maven plugin repository. This command is interactive and will not install any plugins." 
        echo ""
        echo "-? or --help ... well, you know what that command does now. You're reading this..."
        echo ""
        echo ""
        echo "EXAMPLE to install act-morphia into hello-world project:"
        echo "act-plugin.sh -p=~/development/hello-world -i=act-morphia"
        echo ""
        exit
    shift # past argument=value
    ;;
    *)
            # unknown option
    ;;
esac
done


if [[ "${LIST}" == 'YES' ]] ;
    then
    curl -sS https://repo.maven.apache.org/maven2/org/actframework/ >act_output__.tmp
    ACTPLUGINS=$(awk -F '[<>]' '/a href=\"act-/{print $3}' act_output__.tmp)
    echo "--------------------------------"
    echo "Act.Framework Plugins available:"
    echo "--------------------------------"
    echo "${ACTPLUGINS//\// }"
    rm act_output__.tmp
    exit
fi


if [[ "${PROJECTPATH}" == '' ]] || [[ "${PLUGIN}" == '' ]] ; then
    echo "Required parameter missing."
    exit
fi

echo
echo
echo -n "Working..."
#Fix project path (expand ~ if there is one... and deal with relative path)
tempProjectPath=${PROJECTPATH}
if [[ ${tempProjectPath:0:1} == "~" ]] || [[ ${tempProjectPath:0:1} == "/" ]]; then 
    PROJECTPATH=`eval echo "${tempProjectPath}"`
else
    PROJECTPATH="$(pwd)"/"${PROJECTPATH}"
fi

cd ${PROJECTPATH}

curl -sS https://repo.maven.apache.org/maven2/org/actframework/${PLUGIN}/maven-metadata.xml >act_version__.tmp
ACTVERSION=$(awk -F '[<>]' '/latest/{print $3}' act_version__.tmp)
rm act_version__.tmp

sed -e "s/aId/${PLUGIN}/" -e "s/aVer/${ACTVERSION}/" ${RSRCDIR}/plugins/dep.txt >tmp_pom.xml
sed '/<!-- ACT MODULES Do not delete or edit this tag -->/r tmp_pom.xml' pom.xml >new_pom.xml
rm tmp_pom.xml
rm pom.xml
mv new_pom.xml pom.xml

echo
echo "-------------------"
echo "Plugin Installed OK"
echo "-------------------"
echo "Project location: ${PROJECTPATH}"
echo "Plugin name: ${PLUGIN}"
echo "Plugin version: ${ACTVERSION}"

exit

