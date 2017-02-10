/*
Description : This class is used as a controller class for TopNavigation VF component. Purpose of this class is to get, set and manipulate
user data
Created By : Mustafa (Zen4orce)
Created Date : November 2016
*/
public class TopNavigationController {
    public String userImageURL{get;set;}
    //Description:- Purpose of this method is to return User's profile picture.
    public TopNavigationController(){
         String theUserId = UserInfo.getUserId();
         userImageURL = TopNavigationDomain.getUserImage(theUserId);
    } 
}