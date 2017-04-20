#!/bin/bash
#
#       This script for ONLY SHIFT_JIS, DO NOT CHANGE Character code.
#
####
# Input FileName, MS-CP932 (shift-jis)
ORG_FILE='./data_org/hoikusyoitiran.csv'
# Temp FileName, MS-CP932 (UTF-8)
ORG_UTF8='./data_org/hoiku.csv.utf8'

# CSV FileName, MS-CP932 (UTF-8)
CSV_UTF8='./data_org/nurseryData.csv.utf8'
# CSV FileName, MS-CP932 (UTF-8)
CSV_FILE='./data_org/nurseryData.csv'

# Temp FileName, MS-CP932 (UTF-8)
GEOJOSN='./data_org/nurseryData.geojson'

CSV_HEADER='Type,Name,AgeS,Full,Open,Close,OpenSAT,CloseSAT,OpenSTD,CloseSTD,OpenSHRT,CloseSHRT,Extra,Temp,Holiday,Night,Sick,AfterSick,TempByY,Lunch,Vacancy,Add1,TEL,Owner,Y,X,url,Remarks,Kodomo'

echo "----------------------------------------------------"
echo "Convert Script for Nara Hoikusyo MAP from ${ORG_FILE}"
echo "----------------------------------------------------"

echo ""
echo "  Convert Character code from SHIFT_JIS(CP932) tp UTF8 and delete \\r"
echo "  EXEC iconv -f MSCP932 -t UTF-8 ${ORG_FILE} \| sed 's/\r//g' \> ${UTF_FILE}"

iconv -f MS932 -t UTF-8 ${ORG_FILE} | sed 's/\r//g' > ${ORG_UTF8} 

echo "" 
echo "  Make ${CSV_FILE} with item-check and filtering ${ORG_UTF8}"

cp /dev/null ${CSV_UTF8}

cat ${ORG_UTF8} | while read line ; do
    OIFS="$IFS"; IFS=','
    csvItem=($line);
    IFS="$OIFS"
  
    if [ ${csvItem[0]} == "施設種別" ]; then
	outline=${CSV_HEADER} 
    else
	if [ ${csvItem[0]} == "認定こども園" ]; then
	    if [[ ${csvItem[1]} =~ '(保育部分)' ]]; then
		csvItem[0]='認可保育所'
		kodomo="Y"    # HOIKU
	    elif [[ ${csvItem[1]} =~ '(教育部分)' ]]; then
		csvItem[0]='幼稚園'
		kodomo="Y"    # KYOIKU
	    else
		csvItem[0]='認可保育所'
		kodomo="Y"
	    fi
	    csvItem=("${csvItem[@]}" ${kodomo}) 
	elif [ ${csvItem[0]} == "地域型保育事業" ]; then
	    csvItem[0]='認可保育所'
	    csvItem=("${csvItem[@]}" "N") 
	elif [ ${csvItem[0]} == "認可外保育施設" ]; then
	    csvItem[0]='認可外'
	    csvItem=("${csvItem[@]}" "N") 
	elif [ ${csvItem[0]} == '病児保育施設'   ]; then
	    csvItem[0]='認可外'
	    csvItem=("${csvItem[@]}" "N") 
	else
	    csvItem=("${csvItem[@]}" "N") 
	fi

	IFS=','
	##	echo "${csvItem[*]}"
	outline=${csvItem[*]}
	IFS="$OIFS"
    fi

##    echo $outline | sed s/○/Y/g | sed  s/×/N/g 
    echo $outline | sed s/○/Y/g | sed  s/×/N/g >> ${CSV_UTF8}
done


echo ""
echo "  Convert Character code from UTF8 to SHIFT_JIS(CP932)"
echo "  EXEC: iconv -f MS932 -t UTF-8 ${CSV_UTF8} \| sed 's/$/\r/' \> ${CSV_FILE}"

iconv -f UTF-8 -t MS932 ${CSV_UTF8} | sed 's/$/\r/'  > ${CSV_FILE} 

echo ""
echo "  Make GEOJSON form data_org/*"
echo "  EXEC: gulp updatedata"

gulp updatedata

echo ""
echo "  Remove Temporaly Files"

#rm ${ORG_UTF8} ${CSV_UTF8}

echo ""
echo "  Finished" 


