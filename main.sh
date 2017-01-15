#! /bin/bash
readonly DBPATH="databases";
declare -a DBARR ;


##########################################################################################
# create Database  is called in userInterface function
function createDB {
	read -p "Enter Database Name : " dbName;
	if [[ ! -d $DBPATH/$dbName ]];
		then	mkdir $DBPATH/$dbName;
				if [[ $? -eq 0 ]]; then
					echo $dbName" Database Created Successfully" ;
				else	
					echo "Error Done While Creating the Database" ;
				fi
	else	
		echo "This Database is Exists";
	fi

}
########################################################################################
# List Databases in databases Dir  is called in userInterface function
function listDB {
	i=1;
	for DB in `ls $DBPATH`
	do
		DBARR[$i]=$DB;
		let i=i+1;
	done

	if [[ ${#DBARR[@]} -eq 0 ]]; 
		then
			echo "There Is No Database To Be Listed";
			userInterface;
	fi

	echo "This Is List With Available Databases : ";
	i=1;
	for DB in `ls $DBPATH`
	do
		DBARR[$i]=$DB;
		echo $i") "$DB;
		let i=i+1;
	done
	#echo "${DBARR[@]}";

	if [[ ! "$1" ]]; then
		return 0;
	fi

	if [[ "$1"=="show" ]]; then
		echo "done";
		userInterface;
	fi
}
#######################################################################################
# Drop Database From Databases list
function dropDB {
		
		echo "${DBARR[@]}";

	read -p "Choose Database You Want To Drop It From The Above Databases List : " choise ;
	containsElement ${DBARR[$choise]} "${DBARR[@]}";
	if [[  "$?" == "1" ]]; then
		read -p "Are You Sure Droping ${DBARR[$choise]} Database [Y/N] " response;
		case $response in 
			[yY][eE][sS]|[yY]) 
	        	rm -r $DBPATH/${DBARR[$choise]};
	        	DBARR[$choise]="";
	        	echo "${DBARR[@]}";

	    	;;

	    	*)
				printHash;
				userInterface;
			;;
		esac	
	else
		{
			printHash;
			echo "out of range";
			listDB;
			dropDB;
		}

	fi

}
#######################################################################################
# create Table Function
function createTl {
	read -p "Enter Table Name : " tlName ;

	if [[ ! -e $DBPATH/${DBARR[$Cho]}/$tlName.tbl ]] && [[ $tlName != "" ]]
		then	
			touch $DBPATH/${DBARR[$Cho]}/$tlName;
			chmod +x $DBPATH/${DBARR[$Cho]}/$tlName;
			if [[ $? -eq 0 ]]; then
				echo -e "#################$tlName Structure###############" > $DBPATH/${DBARR[$Cho]}/$tlName;
			    echo "Table Name:$tlName " >> $DBPATH/${DBARR[$Cho]}/$tlName;
			    read -p "Enter The Number Of Columns : " tlCol;
			    echo "The Number Of Columns Is:$tlCol" >> $DBPATH/${DBARR[$Cho]}/$tlName;
			    echo -e "#################$tlName Columns###############" >> $DBPATH/${DBARR[$Cho]}/$tlName;
			    for (( i = 1; i <= tlCol ; i++ )); do

			    	read -p "Enter Name Of The Column Number [$i] : " ColName ;
			    	colArr[$i]=$ColName ; 
      				echo  -n "$ColName" >> $DBPATH/${DBARR[$Cho]}/$tlName ;
      				PS3="Enter Column $ColName Type";
      				select colType in Number String
      				do
      					case $colType in
      						"Number")
								echo -e ":Number" >> $DBPATH/${DBARR[$Cho]}/$tlName;
      							break ;
      							;;
      						"String")
								echo -e ":String" >> $DBPATH/${DBARR[$Cho]}/$tlName;
      							break ;
      							;;
      						*)
								echo "You Must Choose The Column Data Type"
      					esac
      				done
			    done

			    while true; do
			    	i=1;
				    for col in "${colArr[@]}"; do
					    echo $i")"$col;
					    i=$((i+1)) ;
				    done
			    	read -p "Detect Primarykey value : " Pkey;
			    	if [ $Pkey -le $tlCol -a $Pkey -gt 0 ]
		        	then 
		            	echo $Pkey >> $DBPATH/${DBARR[$Cho]}/$tlName;
		            	break ;
			        else
			        	echo "You Must Detect Primarykey";
			         	continue ;
			       	fi 	
			    done
			    colArrIndex=1 
		        while [ $colArrIndex -le $tlCol ]
		        do
		         if [ $colArrIndex -eq $tlCol ]
		          then echo -e "${colArr[colArrIndex]}" >> $DBPATH/${DBARR[$Cho]}/$tlName; # we can here add the primary key attribur as a third feild
		         else 
		          echo -n "${colArr[colArrIndex]}:" >> $DBPATH/${DBARR[$Cho]}/$tlName;
		         fi 
		         colArrIndex=$((colArrIndex+1));
		        done
		       echo "############################################################" >> $DBPATH/${DBARR[$Cho]}/$tlName;  
		       
				echo $tlName" Table Created Successfully";
			else	
				echo "Error Done While Creating the Table" ;
			fi
	else	
		echo "This Table  Exists";
	fi
	return $Cho;
}
########################################################################################
# List Tables in Target database
function listTB {
	i=1;
	for TB in `ls $DBPATH/${DBARR[$Cho]}/`
	do
		TBARR[$i]=$TB;
		let i=i+1;
	done

	if [[ ${#TBARR[@]} -eq 0 ]]; 
		then
			echo "There Is No Tables To Be Listed";
			tableOperations $Cho;
			return ;
	fi

	echo "This Is List With Available Tables : ";

	i=1;
	for TB in `ls $DBPATH/${DBARR[$Cho]}/`
	do
		TBARR[$i]=$TB;
		echo $i") "$TB;
		let i=i+1;
	done

	if [[ ! "$1" ]]; then
		return 0;
	fi

	if [[ "$1"=="show" ]]; then
		return $Cho;
	fi

}

#######################################################################################
# Drop Table From Database 
function dropTB {
	read -p "Choose Table You Want To Drop It From The Above Tables List : " choiseT ;
	containsElement ${TBARR[$choiseT]} "${TBARR[@]}";
	if [[  "$?" == "1" ]]; then
		echo "${DBARR[@]}"
		read -p "Are You Sure Droping ${TBARR[$choiseT]} Table [Y/N] " response;
		case $response in 
			[yY][eE][sS]|[yY]) 
	        	rm  $DBPATH/${DBARR[$Cho]}/${TBARR[$choiseT]};
	        	TBARR[$choiseT]="";
	    	;;

	    	*)
				printHash;
				tableOperations $Cho;
			;;
		esac	
	else
		{
			printHash;
			echo "out of range";
			listTB;
			dropTB;
		}

	fi
	return $Cho;

}

#######################################################################################
# Use Database From Databases list and list Tables Operations
function crudOperations {
	
	oldTChoise=$1;
	if [[  "$1" == "" ]]; then
	read -p "Choose Table You Want To Operate On It From The Above Tables List : " tCho ;
	else {
			let tCho=oldTChoise;
		}
	fi
	printHash;
	containsElement ${TBARR[$tCho]} "${TBARR[@]}";
	if [[  $? == 1 ]]; then	
		echo "You Are Using ${DBARR[$Cho]} Database And Operate On ${TBARR[$tCho]} Table";
		options=("Insert" "Update" "Display Table" "Display Record" "Delete Record" "Return TO Pervious Menu" "Return TO Main Menu" "Quit");
		PS3="Enter Your Choice : " ;
		select opt in  "${options[@]}"
		do
			case $opt in
				"Insert")
					printHash;
					insertRw;
					crudOperations $?;
					break ;
					;;
				"Update")
					printHash;
					updateRw;
					crudOperations $?;
					break ;
					;;
				"Display Table")
					printHash;
					displayTB;
					crudOperations $?;
					break ;
					;;
				"Display Record")
					printHash;
					displayRw;
					crudOperations $?;
					break ;
					;;
				"Delete Record")
					printHash;
					deleteRw;
					crudOperations $?;
					break ;
					;;
				"Return TO Pervious Menu")
					tableOperations $Cho;
					;;
				"Return TO Main Menu")
					userInterface;
					;;
				"Quit")
					exit -1 ;
					;;
			esac
		done

	else
		{
			printHash
			echo "out of range";
			listDB;
			dropDB;
		}	
	fi
}

############################################################
#this function for displaying the table columns
# you must send the table name to display it's columns
declare -a tblColArr
function show_columns()
{
       TblName=$1
       colArrIndex=1      
       noCols=`awk -F: '{if (NR == 3) print $2 }' $TblName`
       lineToShow=$((noCols+6)) # this line contains the table column's names
       pkVal=`cut -f1 -d: $TblName | head -$((noCols+5))  | tail -1 `   #the pk value not pk name
       
       pkCol=$((pkVal+4))
       pkColName=`cut -f1 -d: $TblName | head -$pkCol  | tail -1 `   
       echo "Table Columns : "
       while [ $colArrIndex -le $noCols ]
        do
         curColName=`cut -f$colArrIndex -d: $TblName | head -$lineToShow  | tail -1 ` # to show the names of the columns
 	 tblColArr[$colArrIndex]=$curColName  
         echo  " $((colArrIndex)). $curColName " 
	 colArrIndex=$((colArrIndex+1)) 
        done  
       echo "$pkColName Is Primary Key"
       printHash;
       
}



############################################################
#Get Primarykey Line Number

function row_line_no()
{
  
  
  TblName=$1 # the send table
  rowToDisplay=$2 # the send pk
  ########## table Info ###########
  noCols=`awk -F: '{if (NR == 3) print $2 }' $TblName`
  ignoredLines=$(($noCols+7))
  ignoredLines=$((`cat $TblName | wc -l `-ignoredLines))
  
  pkVal=$((noCols+5)) 
  pkVal=`cut -f1 -d: $TblName | head -$pkVal  | tail -1 ` #the pk value not pk name
  #################################
   pkFndLine=`tail -$ignoredLines $TblName | grep -wn $rowToDisplay | cut -f1 -d: `
   pkFndLine=$(($pkFndLine+$noCols+7))
   
   echo $pkFndLine
  
  
  
}

############################################################
#this function for getting the column data types
declare -r FND=1
declare -r NOTFND=0


function chk_pk()
{
    sendPkVal=$1 #the user value
      
       #show_table_info #######
    noCols=`awk -F: '{if (NR == 3) print $2 }' $TblName`
	ignoredLines=$(($noCols+7))
	ignoredLines=$((`cat $TblName | wc -l `-ignoredLines))
	  
	pkVal=$((noCols+5)) 
	pkVal=`cut -f1 -d: $TblName | head -$pkVal  | tail -1 ` #the pk value not pk name
	 tstFound=` tail -$ignoredLines $TblName | cut -f$pkVal -d: | grep -w $sendPkVal ` #grep -x or -w or -wn
	  [ $tstFound ] && echo $FND || echo $NOTFND
	  
	
     
       
}


function get_column_type()
{
  #show_table_info #######
  curNoCols=$1 #index to the column which be enterd
  
  noCols=$((`awk -F: '{if (NR == 3) print $2 }' $TblName`))
  
  curCellDataType=` cut -f2 -d: $TblName | head -$((noCols+4))  | tail -$noCols | head -$curNoCols | tail -1 `
  if [ $curCellDataType = "Number" ] 
   then 
     echo $FND
  else
     echo $NOTFND
  fi  
  
  #echo $curCellDataType

}

############################################################
#this function for Checking the column data types

function chk_column_type()
{
   sendColVal=$1 #the user value
   sendColValType=${sendColVal//[^0-9]/} 
   if [[ $sendColVal == $sendColValType ]]
    then 
      echo $FND
   else
      echo $NOTFND   
   fi   
 
}

#######################################################################################
# Insert row to table
function insertRw {

	noCols=$((`awk -F: '{if (NR == 3) print $2 }' $DBPATH/${DBARR[$Cho]}/${TBARR[$tCho]}`));
	  ###############################################################
	  ignoredLines=$(($noCols+7))
	  ignoredLines=$((`cat $DBPATH/${DBARR[$Cho]}/${TBARR[$tCho]} | wc -l `-ignoredLines))
	  pkVal=$((noCols+5)) 
	  pkVal=`cut -f1 -d: $DBPATH/${DBARR[$Cho]}/${TBARR[$tCho]} | head -$pkVal  | tail -1 ` #the pk value not pk name
	  
	 ####################### 
	 curNoCols=1 #index to the column which be enterd
	 echo "Insert The Columns Values In this Sequense : " # You Want To Insert Into..pk mandatory "
	 # to display the columns of the selected table 
	 show_columns $DBPATH/${DBARR[$Cho]}/${TBARR[$tCho]}          
	 
	 while [ $curNoCols -le $noCols ]
	 do
	  ################################## Check The Cell Data Type #################
	  while true 
	  do 
	   read -p "Enter The $curNoCols Cell Value [You Must Enter Value ] : "  cellValu # update using pk
	    
	        curCellDataType=$(get_column_type $curNoCols )
	        curColDataType=$(chk_column_type $cellValu )
	      
	        if [[ $cellValu ]] && [[ $curCellDataType -eq $curColDataType ]] && [[ $curCellDataType -eq 1 ]]
	          then break 
	         
	        elif [[ $cellValu ]] && [[ $curCellDataType -eq $curColDataType ]] && [[ $curCellDataType -eq 0 ]]
	          then break 
	          
	         else
	             {
	              echo "Column Data Type Does Not Match "
	    
	             }  
	         fi  
	                
	     done
	      
	  ################### Check The Primary Key Value ##################  
	  if [ $curNoCols -eq $pkVal ]
	  then 
	    {
	          chkPkRtrn=$(chk_pk $cellValu)
	          if [ $chkPkRtrn -eq 1 ]
	           then
	            {
	               echo "There Is A Row Has This Pk Val ... Try Again"
	               break             
	            
	            }
	          
	          fi
	       }  
	     fi
	     
	     ####################################################################
	      if [ $curNoCols -eq $noCols ]
	       then echo -e "$cellValu" >> $DBPATH/${DBARR[$Cho]}/${TBARR[$tCho]} 
	      else
	        echo -n "$cellValu:" >> $DBPATH/${DBARR[$Cho]}/${TBARR[$tCho]}  
	      fi
	  
	  curNoCols=$((curNoCols+1))
	 done
	 return $tCho;
 
}


############################################################
#Update Table with Primarykey

function updateRw()
{
	TblName=$DBPATH/${DBARR[$Cho]}/${TBARR[$tCho]}
	noCols=$((`awk -F: '{if (NR == 3) print $2 }' $DBPATH/${DBARR[$Cho]}/${TBARR[$tCho]}`));
	pkVal=$((noCols+5)) 
	pkVal=`cut -f1 -d: $DBPATH/${DBARR[$Cho]}/${TBARR[$tCho]} | head -$pkVal  | tail -1 ` #the pk value not pk name
 #######################
 while true 
  do 
   read -p "Which Row You Want To Update Using Primarykey  : " pkToUpdate # update using pk
    if [ $pkToUpdate ]
     then break
    fi 
  done
  
   pkFnd=$(chk_pk $pkToUpdate)
  if [ $pkFnd == 1 ]
  then 
   {
    rowToUpdate=$(row_line_no $TblName $pkToUpdate)
     echo "##################" 
     echo "The Row Values Are : "
     sed -n "${rowToUpdate}p" $TblName 
     echo "##################"  
     sed -i "${rowToUpdate}d" $TblName #&& echo "Row Deleted Successfully" 
   }
  else
   {
    echo "Sorry...This Is Not A PK Value .. Try Again Later "
   } 
  fi

  ############33

  echo "Enter The Row New Values : "
  show_columns $TblName            # to display the columns of the selected table 
  curNoCols=1
  
 
  while [ $curNoCols -le $noCols ]
  do
   
   ################################## Check The Cell Data Type #################
  while true 
  do 
   read -p "Enter The $curNoCols Cell Value [You Must Enter Value ] : "  cellValu # update using pk
    
        curCellDataType=$(get_column_type $curNoCols )
        curColDataType=$(chk_column_type $cellValu )
      
        if [ $cellValu -a $curCellDataType -eq $curColDataType -a $curCellDataType -eq 1 ]
          then break 
         
        elif [ $cellValu -a $curCellDataType -eq $curColDataType -a $curCellDataType -eq 0 ]
          then break 
          
         else
             {
              echo "Column Data Type Does Not Match"
    
             }  
         fi  
                
     done

  
  ##################### Check The Primary Key Value ##################  
  if [ $curNoCols -eq $pkVal ]
  then 
    {
         chkPkRtrn=$(chk_pk $cellValu)
          if [ $chkPkRtrn -eq 1 ]
           then
            {
               echo " Dublicated Primarykey Value Which Should Be Unique ";
               continue ;             
            
            }
          
          fi
       }  
     fi
     ####################################################################
      if [ $curNoCols -eq $noCols ]
       then echo -e "$cellValu" >> $TblName 
      else
        echo -n "$cellValu:" >> $TblName  
      fi
  
  curNoCols=$((curNoCols+1))
 done
 echo "Row Updated Successfully ";
 return $tCho;

}


############################################################
#Display Row With Primarykey
function displayRw()
{
  
  	TblName=$DBPATH/${DBARR[$Cho]}/${TBARR[$tCho]}
	noCols=$((`awk -F: '{if (NR == 3) print $2 }' $DBPATH/${DBARR[$Cho]}/${TBARR[$tCho]}`));
	ignoredLines=$(($noCols+7))
  	ignoredLines=$((`cat $TblName | wc -l `-ignoredLines))
	pkVal=$((noCols+5)) 
	pkVal=`cut -f1 -d: $DBPATH/${DBARR[$Cho]}/${TBARR[$tCho]} | head -$pkVal  | tail -1 ` #the pk value not pk name  rowCounter=$(($noCols+8))
    rowCounter=$(($noCols+8))
  #################################
  while true 
  do 
   read -p "Enter The Primary Key You Want To Display It's Record: " rowToDisplay
    if [ $rowToDisplay ]
     then break
    fi 
  done
  #################################
  
  pkFnd=$(chk_pk $rowToDisplay)
  if [ $pkFnd == 1 ]
  then 
   {
     printHash; 
     echo "The Result Is : ";
     pkFndLine=`tail -$ignoredLines $TblName | grep -wn $rowToDisplay | cut -f1 -d: `;
     pkFndLine=$(($pkFndLine+$noCols+7));
     sed -n "${pkFndLine}p" $TblName  ;
     printHash;
   }
  else
    echo "No Record Found With This Primarykey Value ";
  fi     
   
  
  return $tCho
  
}

############################################################
#Display Table Data
function displayTB()
{
 TblName=$DBPATH/${DBARR[$Cho]}/${TBARR[$tCho]};
 printHash;
 echo "Table Data And  Structure : ";
 cat $TblName;
 return $tCho
}

############################################################
#Delete Row Using Primarykey
deleteRw()
{
 
 
  TblName=$DBPATH/${DBARR[$Cho]}/${TBARR[$tCho]};
  while true 
  do 
   read -p "Enter The Primarykey You Want To Delete It's Record : " pkToDelete # update using pk
    if [ $pkToDelete ]
     then break
    fi 
  done
 
  pkFnd=$(chk_pk $pkToDelete)
  if [ $pkFnd == 1 ]
  then 
   {
    rowToDelete=$(row_line_no $TblName $pkToDelete)
     printHash;
     echo "Deleted Values Are : "
     sed -n "${rowToDelete}p" $TblName 
     printHash;
     sed -i "${rowToDelete}d" $TblName && echo "Row Deleted Successfully" 
   }
  else
   {
    echo "No Record Found With This Primarykey Value"
   } 
  fi
  return $tCho;
}


#######################################################################################
# Use Database From Databases list and list Tables Operations
function tableOperations {
	
	oldChoise=$1;
	if [[  "$1" == "" ]]; then
		read -p "Choose Database You Want To Use It From The Above Databases List : " Cho ;
		else {
			let Cho=oldChoise;
		}
	fi
	printHash;
	containsElement ${DBARR[$Cho]} "${DBARR[@]}";
	if [[  $? == 1 ]]; then	
		echo "You Are Using ${DBARR[$Cho]} Database";
		options=("create New Table" "CRUD Table" "Show Tables" "Drop Table" "Return TO Main Menu" "Quit");
		PS3="Enter Your Choice : " ;
		select opt in  "${options[@]}"
		do
			case $opt in
				"create New Table")
					printHash;
					createTl;
					tableOperations $?;
					break ;
					;;
				"CRUD Table")
					printHash;
					listTB;
					crudOperations;
					break ;
					;;
				"Show Tables")
					printHash;
					listTB "show";
					tableOperations $?;
					break ;
					;;
				"Drop Table")
					printHash;
					listTB;
					dropTB;
					tableOperations $?;
					break ;
					;;
				"Return TO Main Menu")
					userInterface;
					;;
				"Quit")
					exit -1 ;
					;;
			esac
		done

	else
		{
			printHash
			echo "out of range";
			listDB ;
			tableOperations;
		}	
	fi
}



#######################################################################################
# check if array contain an element return 1 if found return 0 if not
containsElement () {
    local e
    for e in "${@:2}"
    do 
        if [[ "$e" == "$1" ]]
            then 
                return 1;
        fi 
    done
  
    return 0
}
#######################################################################################
# print #
function printHash {
	echo "############################################################################";
}


##########################################################################################
# Just Welcome Message
function welcome {
	echo -e "\n \n \nWelcome to Habib DBMS\n \n \n";
}

########################################################################################
function  userInterface {
	printHash;
	options=("create New Database" "Use Database" "Show Databases" "Drop Databas" "Quit");

	PS3="Enter Your Choice : " ;

	select opt in  "${options[@]}"
	do
		case $opt in
			"create New Database")
				printHash
				createDB;
				userInterface;
				break ;
				;;
			"Use Database")
				printHash;
				listDB;
				tableOperations;
				break ;
				;;
			"Show Databases")
				printHash;
				listDB "show";
				break ;
				;;
			"Drop Databas")
				printHash;
				listDB;
				dropDB;
				userInterface
				break ;
				;;
			"Quit")
				exit -1 ; 

				;;
		esac
	done
};
printHash;
welcome;
userInterface;

