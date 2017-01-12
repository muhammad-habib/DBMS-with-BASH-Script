#! /bin/bash
#create user menu function

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
		printHash;
		echo "out of range";
		listDB;
		dropDB;

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
	options=("create New Database" "Choose Database" "Show Databases" "Drop Databas" "Quit");

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
			"Choose Database")
				printHash;
				listDB;
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
				return ;
				;;
		esac
	done
};
printHash;
welcome;
userInterface;

