/*Description : This class is used as a Domain class for CreateOpportunity VF component. Purpose of this class is  manipulate
opportunity data
Created By : Mustafa 
Created Date : November 2016*/
public with sharing class CreateEditOpportunityDomain {
    /*Description : Purpose of this method is insert or update Opportunity.*/
    public static boolean upsertOpportunity(Opportunity opp, String AccountId){
        opp.AccountId = AccountId;
        opp.StageName = 'Prospecting';
        opp.Approval_Status__c ='Not Submitted';
        Database.UpsertResult result = Database.upsert(opp);
        boolean isSuccess = result.isSuccess();
        return isSuccess;
    }
    
    /*Description : Purpose of this method is insert new Opportunity and submit it to 
    marketing department for approval.*/
    public static void submitNewOpportunityForApproval(Opportunity opp,String SelectedUser){
    	opp.Approver__c = SelectedUser;
        opp.StageName = 'Prospecting';
        opp.Approval_Status__c ='Submitted';
    	insert opp;
    }
    
    /*Description : Purpose of this method is update existing Opportunity and submit it to 
    marketing department for approval.*/
    public static void submitExistingOpportunityForApproval(Opportunity opp, String SelectedUser){
     	 opp.Approver__c = SelectedUser;
         opp.Approval_Status__c ='Submitted';
    	update opp;
    }
    
    /*Description : Purpose of this method is to delete opportunity record.*/
    public static boolean deleteOpportunity(Opportunity oppToDelete){
        Database.DeleteResult drList = Database.delete(oppToDelete);
        boolean isSuccess = drList.isSuccess();
        return isSuccess;
    }
    
    /*Description : Purpose of this method is to delete opportunity record.*/
    public static boolean updateOpportunity(Opportunity opp, String buttonAction){
        opp.Approval_Status__c = buttonAction;
        database.saveResult dbRS = database.update(opp);
        Boolean isSuccess = dbRS.isSuccess();
        return isSuccess;
    }
}