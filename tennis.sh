#!/bin/bash
#Sagiv Antebi

printBoard(){
	echo " Player 1: ${2}         Player 2: ${3} "
	echo " --------------------------------- "
	echo " |       |       #       |       | "
	echo " |       |       #       |       | "
	
	
	case "$1" in
		0)  echo " |       |       O       |       | "
			;;
		1)  echo " |       |       #   O   |       | "
			;;
		2)  echo " |       |       #       |   O   | "
			;;
		3)  echo " |       |       #       |       |O"
			;;
		-1) echo  " |       |   O   #       |       | "
		   ;;
		-2) echo  " |   O   |       #       |       | "
		   ;;
		-3) echo  "O|       |       #       |       | "
		   ;;
		*) echo "Signal number $1 is not processed"
		   ;;
	esac
	
	echo " |       |       #       |       | "
	echo " |       |       #       |       | "
	echo " --------------------------------- "

}

checkIfNumber(){
	if ! [[ $1 =~ ^[0-9]+$ ]]
	then
	   return 1
	fi
	return 0
}

checksIfGreaterThan(){
	  if (($1 > $2 ))
	  then
	  	return 1
	  fi
	  return 0
}

getNumbers(){
	bool1=1
	bool2=1
	echo "PLAYER 1 PICK A NUMBER: "
	read -s player1Pick
	checkIfNumber "$player1Pick"
	bool1=$?
	if [[ bool1 -eq 0 ]]; then
			checksIfGreaterThan "$player1Pick" "$1"
			bool2=$?
		fi
	while [ $bool1 == 1 -o $bool2 == 1 ]
	do
		echo "NOT A VALID MOVE !"
		echo "PLAYER 1 PICK A NUMBER: "
		read -s player1Pick
		checkIfNumber "$player1Pick"
		bool1=$?
		if [[ bool1 -eq 0 ]]; then
			checksIfGreaterThan "$player1Pick" "$1"
			bool2=$?
		fi

	done
	bool1=1
	bool2=1
	echo "PLAYER 2 PICK A NUMBER: "
	read -s player2Pick
	checkIfNumber "$player2Pick"
	bool1=$?
	if [[ bool1 -eq 0 ]]; then
		checksIfGreaterThan "$player2Pick" "$1"
		bool2=$?
	fi
	while [ $bool1 == 1 -o $bool2 == 1 ]
	do
		echo "NOT A VALID MOVE !"
		echo "PLAYER 2 PICK A NUMBER: "
		read -s player2Pick
		checkIfNumber "$player2Pick"
		bool1=$?
		if [[ bool1 -eq 0 ]]; then
			checksIfGreaterThan "$player2Pick" "$2"
			bool2=$?
		fi
	done
	
	player1Score=$[$player1Score-$player1Pick]
	player2Score=$[$player2Score-$player2Pick]
}



moveBall(){
	if [ $player1Pick -eq $player2Pick ]
	then
		ballPosition=$[$ballPosition+0]
	elif [ $player1Pick -gt $player2Pick ]
	then 
		if [ $ballPosition -ge 0 ]; then
			ballPosition=$[$ballPosition+1]
		else
			ballPosition=1
		fi
	else
		if [ $ballPosition -le 0 ]; then
		ballPosition=$[$ballPosition-1]
		else
			ballPosition=-1
		fi
		
	fi
	printBoard "$ballPosition" "$player1Score" "$player2Score"
	echo -e "       Player 1 played: ${player1Pick}\n       Player 2 played: ${player2Pick}\n\n"
}

checkWinner(){
	if [ $ballPosition -eq 3 ]
	then
		winner=$[$winner+1]
		echo "PLAYER 1 WINS !"
		return
	fi
	if [ $ballPosition -eq -3 ]
	then
		winner=$[$winner+1]
		echo "PLAYER 2 WINS !"
		return
	fi
	if [ $player1Score -eq 0 -a $player2Score -eq 0 ]
	then
		winner=$[$winner+1]
		if [ $ballPosition -eq 0 ]
		then
			echo "IT'S A DRAW !"
			return
		elif [ $ballPosition -ge 1 ]
		then
			echo "PLAYER 1 WINS !"
			return
		else
			echo "PLAYER 2 WINS !"
			return
		fi
	fi
	if [ $player1Score -eq 0 ]
	then
		echo "PLAYER 2 WINS !"
		return
	fi
	if [ $player2Score -eq 0 ]
	then
		echo "PLAYER 1 WINS !"
		return
	fi
}


declare -i player1Score=50
declare -i player2Score=50
declare -i ballPosition=0
declare -i winner=0
printBoard "$ballPosition" "$player1Score" "$player2Score"
while [ $player1Score -gt 0 -a $player2Score -gt 0 -a $winner -eq 0 ]
do
	getNumbers "$player1Score" "$player2Score"
	moveBall
	checkWinner
done


