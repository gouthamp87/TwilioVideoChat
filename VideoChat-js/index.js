const express = require('express')
const app = express()
const port = 5050
const twilioWrapper = require('./TwilioWrapper');
var twilio = new twilioWrapper();
// var meetingRoomTokens = {}; // Contains objects in the format of "Username" : "Token"
app.use('/js', express.static(__dirname + '/js'));
app.use('/', express.static(__dirname + '/'));
app.get('/', (request, response) => {
  response.send('Hey you Finally Made it till here, you moron!!!');
})

app.get('/getRoom', getRoom);


app.listen(port, (err) => {
  if (err) {
    return console.log('something bad happened', err)
  }
  console.log(`server is listening on ${port}`);
  // console.log('Creating a new Twilio Instance');
  
  // console.log("Hey the twilio client info is", twilio.client);
  // console.log("Creating a new Twilio Chat Room");
  // twilio.client.video.rooms.create({uniqueName:'Test-Room1'}).then(room=>console.log(room)).done();
  // console.log
})


function getRoom(req,res){
  console.log("Trying to Get a room");
  var response = {};
  var params = req.query;
  console.log("The Params we got are:", params);
  var userID = params['userID'];
  console.log("User id we got is ", userID);
  // if(meetingRoomTokens.hasOwnProperty(userID)){
  //   console.log("We already have a Meeting room with ", userID);
  //   if(meetingRoomTokens[userID]){
  //     console.log('We have a userID and AccessToken, Re-using them');
  //   } else {
  //     console.log('We have a userID but no AccessToken, Generatin AccessToken');
  //     meetingRoomTokens[userID] =  twilio.getVideoToken(userID);
  //   }
  //   response['AccessToken'] =  meetingRoomTokens[userID],
  //   response['RoomName']  = userID+'Room';
  // }else {
  // console.log('The Response we have is:', response);
  // if(typeof(response) === undefined){
    console.log("We have neither a userID nor Access Token, Generating Both");
    // meetingRoomTokens[userID] = twilio.getVideoToken(userID);
    response['AccessToken'] =  twilio.getVideoToken(userID);
    // response['RoomName']  = userID+'Room';
  // }
  res.send(response);
}
