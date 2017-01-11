#! /bin/bash
#create user menu function

readonly DBPATH="databases";
declare –a DBARR;


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
		echo "This Database is Exists"

	fi

}

function listDB {
	#read -p "Choose Your Database From The Below List : " choise ;
	local i=0;
	for DB in `ls $DBPATH`
	do
	   DBARR[$i]=$DB;
	   let i=i+1;
	done
	

}






function  userInterface {

	echo -e "\n \n \nWelcome to Habib DBMS\n \n \n";

	options=("create New Database" "Choose Database" "Quit");

	PS3="Enter Your Choice : " ;

	select opt in  "${options[@]}"
	do
		case $opt in
			"create New Database")
				createDB;
				break ;
				;;
			"Choose Database")
				listDB;
				break ;
				;;
			"Quit")
				break ;
				;;
		esac
	done
};

userInterface;

