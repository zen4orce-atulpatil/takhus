/*
Description : This class is used as a Domain class for TopNavigation Component.
Created By : Mustafa
Created Date : November 2016
*/
public class TopNavigationDomain {
    //Purpose of this method is to return User profile Image.
    public static String getUserImage(String theUserId){
        String UserImageURL = [SELECT SmallPhotoUrl FROM User WHERE User.ID = :theUserId LIMIT 1].SmallPhotoUrl;
        return UserImageURL;
    }
}