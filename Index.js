"use strict";
var app = require('express')();
var http = require('http').Server(app);
var io = require('socket.io')(http);

var player1 = 0;
var player2 = 0;
var numberOfPlayers = 0;
var player1Points = 0;
var player2Points = 0;
var startsPlaying = 1; // by default Player1 starts the game
var roolADieJustOnce = false; // to make sure it will just roll once die at the beginning of the game (The die is used to know who starts the game)

io.on('connection', function(socket){
  console.log('A user connected');

  	if (numberOfPlayers == 0){
  		player1 = new Player(createPLayerTable(), "Player1" );
  		console.log('Player1 created.');
  		debugWhoIsPlayer(player1);
  		numberOfPlayers++;
  		sendTableToClient(player1.tablePlayer);
  		socket.emit('player', player1.playerName);

  	} else if (numberOfPlayers == 1){
  		player2 = new Player(createPLayerTable(), "Player2" );
  		console.log('Player2 created.');
  		debugWhoIsPlayer(player2);
  		numberOfPlayers++;
  		sendTableToClient(player2.tablePlayer);
  		socket.emit('player', player2.playerName);

  	} else{
  		console.log('There is already 2 players, the maximum of players supported is 2.');
  	}
    
    socket.on('turn', function(playerName){
        console.log(playerName + ' turn');
        if (playerName == '[Player1]' || playerName == 'Player1' ){
          io.sockets.emit('turn', 'Player2');
        }else{
          io.sockets.emit('turn', 'Player1');
        }
        
    });

    socket.on('rollADie', function(){

      if (roolADieJustOnce == false){
          console.log('Rolling a die...');
          startsPlaying=Math.ceil(Math.random()*2);
          console.log('Die number = ' + startsPlaying);
          roolADieJustOnce = true;
      }
      
        if (startsPlaying == 1){
          // Player1 starts the game
          console.log(player1.playerName + ' starts the game.')
          io.sockets.emit('turn', 'Player1');

        }else if (startsPlaying == 2){
          // Player2 starts the game
          console.log(player2.playerName +' starts the game.')
          io.sockets.emit('turn', 'Player2');
        }

    });

        socket.on('points_increase', function(player_id){

        if (player_id == "[Player1]"){
          player1.points++;
          console.log("Player1 points " + player1.points);

          if (player1.points == 12){    
             io.sockets.emit('end_game', player_id);
          }

        }else if(player_id == "[Player2]"){
          player2.points++;
          console.log("Player2 points " + player2.points);

           if (player2.points == 12){
              io.sockets.emit('end_game', player_id);
          }
        }

        io.sockets.emit('points_increase', player_id);

    });

        socket.on ('teste', function (data) {
        io.sockets.emit ('messageSuccess', data);
});


    socket.on('login', function(msg){

    	if (msg == "natan"){

        	console.log('login: ' + msg);
        	console.log(msg + " Logged!");
        	socket.emit('loginSuccess', 'Login successful');
    	}else{
    		console.log("Login faild!");
        socket.emit('loginFail', 'Login fail');
    	}


    });

    function sendTableToClient(table){
	  for (var i = 0; i< table.length; i++){
			socket.emit('sendTableToClient', parseInt(table[i]));
			console.log('sendTableToClient: ' +  table[i]);
		}	
}

});

http.listen(8900, function(){
  console.log('listening on *:8900');
});



function debugWhoIsPlayer(player){
	console.log('Player information:');
	console.log('Name:' + player.playerName);
	console.log('Table:' +player.tablePlayer);
}

function createPLayerTable(){
	var tableGame = []
	while(tableGame.length < 12){ // 12 cuz each player has 12 ships
  		var randomnumber=Math.ceil(Math.random()*28) // 28 cuz we have 28 cells in game
  		var found=false;
  		for(var i=0;i<tableGame.length;i++){
			if(tableGame[i]==randomnumber){found=true;break}

  			}
  			if(!found)tableGame[tableGame.length]=randomnumber;
			}
			return tableGame;
}

class Player {
  constructor(tablePlayer, playerName) {
    this.tablePlayer = tablePlayer;
    this.playerName = playerName;
    this.points = 0;
  }
}





