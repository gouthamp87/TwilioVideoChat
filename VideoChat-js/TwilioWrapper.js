/*
Wrapper for Twilio interfaces
This would help us wrap all the Twilio server calls and abstract any unnecssary sensitive info from the user.
*/

const TWILIO_ACCOUNT_SID  = 'AC16db4b7ff96e1da499de0396e1c95a52';
const TWILIO_AUTH_TOKEN  = '7c81b869d9fc066602c203cb917d1fd1';
const API_KEY_SID = 'SK679e6380826d4ccc8476632e0fd17230';
const API_KEY_SECRET = 'jvbT73YSALhfoFAuqj8e666DjwhL4QFF';
const twilio = require('twilio');
const AccessToken = require('twilio').jwt.AccessToken;
const VideoGrant = AccessToken.VideoGrant;
class TwilioWrapper {
    constructor(){
      this.client = new twilio(TWILIO_ACCOUNT_SID,TWILIO_AUTH_TOKEN);
    }

    getVideoToken(userID) {
      // Generate the Access Token.
      if(!userID){
        userID = 'NothingGivenTestRandom';
      }
      console.log("The user ID to be used is:", userID);
      // TODO: We need logic here to check if the current user has a video Token already generated.
      // If it is already generated re-use that.
      var accessToken = new AccessToken(TWILIO_ACCOUNT_SID,API_KEY_SID,API_KEY_SECRET);
      // Assign a user Identity  to the token.
      accessToken.identity = userID;
      // Generate a Room for the user token.
      var grant = new VideoGrant();
      grant.room =  'GouthamRoom';
      accessToken.addGrant(grant);
      // Serialize the token as a JWT
      var jwt = accessToken.toJwt();
      console.log(jwt);
      return jwt;
      // return {
      //   'AccessToken': jwt,
      //   'RoomName': grant.room
      // };
    }
}

module.exports = TwilioWrapper;
