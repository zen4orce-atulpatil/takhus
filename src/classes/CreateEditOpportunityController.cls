/*
Description : This class is used as a controller class for CreateOpportunity VF component. Purpose of this class is to get, set and manipulate
opportunity data
Created By : Mustafa 
Created Date : November 2016
*/
public class CreateEditOpportunityController {
    
    public Opportunity opp;
    public Opportunity oppRec{get;set;}
    public String accId{get;set;}
    public String selectedUser{get;set;}
    public String notificationMessage{get;set;}
    public String notificationType{get;set;}
    public List<Account> lstAccounts;
    public List<User> lstUser;
    List<SelectOption> lstAccountOptions;
    List<SelectOption> lstUserOptions;
    
    /*Description : Purpose of this method is to get the opportunity details on CreateOpportunity panel(UI)*/
    public Opportunity getOpp(){
        try{
            if(oppRec==null){
                opp = new Opportunity();
                accId = 'Select';
            }else{
                    opp = oppRec;
                    accId= oppRec.AccountId;
                    selectedUser = oppRec.Approver__c;
            }   
        }catch(Exception e){
          System.debug('ERROR'+e.getMessage()); 
       	}
        return opp; 
    }
	
	/*Description : Purpose of this method is to prepare a list of type SelectOption for account object*/
    public List<SelectOption> getAccounts(){
        try{
            if(lstAccounts == null){
                lstAccountOptions = new List<SelectOption>();
                lstAccounts = TurboPLMSelector.accountList();
                lstAccountOptions.add(new SelectOption('001000000000000','--Select--'));
                for(Account varAccount : lstAccounts){
                    lstAccountOptions.add(new SelectOption(varAccount.Id, varAccount.Name));
                }
            }
        }catch(Exception e){
           System.debug('ERROR'+e.getMessage()); 
       }            
        return lstAccountOptions;
    }
    
    /*Description : Purpose of this method is to prepare a list of type SelectOption for User object*/
    public List<SelectOption> getUsersByDept(){
        selectedUser = '0';
        try{
            if(lstUser == null){
                lstUserOptions = new List<SelectOption>();
                lstUserOptions.add(new SelectOption('0','Select'));
                lstUser = TurboPLMSelector.getUsersOfSameDept('Marketing');
                for(User usr : lstUser){
                    lstUserOptions.add(new SelectOption(usr.Id,usr.Name));
                }
            }
        }catch(Exception e){
           System.debug('ERROR'+e.getMessage()); 
       }            
        return lstUserOptions;
    }
    
    /*Description : Purpose of this method is save the opportunity record details*/
    public void saveOpportunity()
    {
        try{
            if(opp.Id == null){
                notificationMessage = Label.SaveMessage;
                notificationType = 'success';
            }
            else{
                notificationMessage = Label.UpdateMessage;  
                notificationType = 'success';
            }
            if(opp.AccountId == '001000000000000'){
                opp.AccountId = null;
            }
            if(!CreateEditOpportunityDomain.upsertOpportunity(opp,opp.AccountId)){
                notificationMessage = Label.FailureMessage;
                notificationType = 'error';
            }
        }
        catch(System.DMLException e){
            notificationMessage = Label.FailureMessage;
           	notificationType = 'error';
        	ApexPages.addMessages(e);
        }
    }
    
    /*Description : Purpose of this method is save the new opportunity or existing opportunity 
    record details and send it to approver for approval process*/
     public void submitForApproval() {
     	try{
            if(opp.Id == null) {
                CreateEditOpportunityDomain.submitNewOpportunityForApproval(opp, selectedUser);
                notificationMessage = Label.SubmitMessage;
                notificationType = 'success';  
            }
            else{
                CreateEditOpportunityDomain.submitExistingOpportunityForApproval(opp, selectedUser);
                notificationMessage = Label.SubmitMessage;
                notificationType = 'success'; 
            }
        }
        catch(System.DMLException e){
            notificationMessage = Label.FailureMessage;
           	notificationType = 'error';
            ApexPages.addMessages(e);
        }
     }
}